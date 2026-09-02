## Django Configuration & Environment Variables

**Problem.** The Django `settings.py` file frequently uses `os.environ.get("VAR", "fallback_value")`. In development, this is convenient as it allows the application to run with default values (e.g., `SECRET_KEY = "my-secret-key-123"`). However, this practice embeds secrets or defaults directly into the source code, which is unsafe for production or CI/CD builds, as it can lead to accidental commits of credentials or failure to detect when the application *should* be reading from a different source (like a proper secrets manager).

**Solution.** The learning here is the pattern of *separating* default/development fallbacks from production requirements. For container deployment, the solution requires ensuring that production-critical variables (`SECRET_KEY`, `ALLOWED_HOSTS`, etc.) are *always* injected at runtime, even if the file defaults to a safe, non-functional value like `None` or a placeholder. The fix applied was ensuring `DEBUG` defaults to `"False"` in the environment variable reading, and for the `SECRET_KEY`, while a placeholder remains, the build step must ensure this is overridden by the CI/CD system.

**How it works.**
The use of `os.environ.get(key, default_value)` makes the settings file resilient to missing environment variables during local testing or initial container build stages. The "learning" is recognizing the inherent danger of the `default_value` when that value could be used in production. The appropriate pattern is to use a pattern that fails loudly if the variable is missing in production, rather than providing a default that silently allows insecure behavior.

**Alternatives and tradeoffs.**
The ideal alternative is to wrap the entire `settings.py` loading in a function that explicitly checks for the presence of a minimum set of required environment variables, failing immediately if any are absent. The current approach prioritizes *bootstrapping* (allowing local dev) over strict *security*, which is a necessary tradeoff when bootstrapping a project, but it must be clearly documented as such.

**Gotchas.**
The fallback value for `SECRET_KEY` (`"my-secret-key-123"`) is only suitable for local development. Never commit logic that relies on this default being secure enough for staging or production environments.

```python
# The pattern observed: reading ENV or falling back to a development default.
SECRET_KEY = os.environ.get("SECRET_KEY", "my-secret-key-123")
DEBUG = os.environ.get("DEBUG", "False")
```