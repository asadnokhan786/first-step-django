## Docker Deployment Pattern

**Problem.** Running a Django application inside a container requires coordinating multiple, distinct steps: installing Python dependencies, collecting static files, setting up the correct user permissions, and finally, starting the web server using a dedicated entrypoint script, all while adhering to Docker best practices (like multi-stage builds and avoiding baking secrets into image layers).

**Solution.** The solution implemented a multi-stage Docker build. The first stage handles dependency installation (`requirements.txt`) and static file collection in an isolated environment. The final stage creates a non-root user (`app`), copies only necessary code, and uses an explicit `entrypoint.sh` script to handle process management (running migrations, then starting Gunicorn). This pattern solves the problem of process management within containers, which is more robust than just running `gunicorn` directly.

**How it works.**
The build uses `COPY requirements.txt` first, allowing Docker's layer caching to invalidate only when dependencies change. The `entrypoint.sh` intercepts the container startup, guaranteeing migrations run *before* Gunicorn starts serving traffic, and then executes `gunicorn` with specific bind addresses and workers. This chain ensures database state is correct upon first startup.

**Alternatives and tradeoffs.**
An alternative would be to use a fully managed service (like Elastic Beanstalk or ECS) that abstracts away the Dockerfile/Entrypoint process entirely. This approach, however, provides maximum control over the exact execution flow, which is necessary for complex, bespoke setups.

**Gotchas.**
1. **Build Secrets:** Notice the `SECRET_KEY=build-time-only DEBUG=0` in the `RUN` command. These variables *must* be passed via build arguments (`--build-arg`) or another secrets mechanism in production; baking them into the `RUN` command as plain text is visible in the image history.
2. **Process Exit:** The `entrypoint.sh` uses `exec gunicorn...`. This is critical because it ensures that the `gunicorn` process, and not the shell script itself, becomes the primary process ID (PID 1) inside the container, which is required for signals (like graceful shutdown on `docker stop`).

```bash
# Snippet from entrypoint.sh (PID 1 management)
exec gunicorn myproject.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    ...
```