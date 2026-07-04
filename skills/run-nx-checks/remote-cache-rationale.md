# Why the remote cache is off by default

Local affected runs gain little from a remote read-through cache, and inside the sandbox the auth
side effects of the cloud backends are actively harmful. Two families of remote-cache backends
exist for Nx, and the skill disables both because we can't always tell from outside which (if any)
is in use:

- **Nx Powerpack remote caches** (`@nx/azure-cache`, `@nx/s3-cache`, `@nx/gcs-cache`). All three are
  built on the shared `powerpack-utils` and read `NX_POWERPACK_CACHE_MODE` — setting it to
  `no-cache` short-circuits both reads and writes, so the cloud SDK's credential chain never starts.
- **Nx Cloud** (the SaaS read-through cache; gated by `NX_NO_CLOUD=true`).

What actually goes wrong in the sandbox (observed with `@nx/azure-cache`, but the pattern
generalises to the other Powerpack backends and any code path that calls `DefaultAzureCredential` /
`DefaultAwsCredentialProvider` / etc.):

- The cloud SDK probes a chain of credential providers (e.g. Azure: Environment → ManagedIdentity →
  VSCode → PowerShell → AzDev CLI → `az`) inside the node process. Each unavailable provider costs
  multiple seconds before falling through.
- The `az` fallback tries to write to `~/.azure/commands/*.log`, which the sandbox denies
  (`PermissionError: Operation not permitted`), causing further failures down the chain.
- A shell-side check like `az account show` returning success does **not** mean the in-process
  credential chain will succeed — they're different code paths. So an autodetect based on `az`
  status is unreliable. Always disable, don't autodetect.

Net result without the prefix: every nx target hangs for ~5–10s of credential probing per
invocation, four times over (format / lint / test / build), for no benefit. Inlining both env vars
short-circuits whichever backend is actually in use; the unused one is a harmless no-op.
