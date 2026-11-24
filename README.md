# fpga-env

Containerized FPGA toolchains for simulation, synthesis, and implementation.

## Structure

- `containers/ghdl/`: GHDL image with LLVM backend, Python, VUnit and GTKWave.
- `examples/vhdl/`: VHDL counter example with VUnit and fpgather.
- `scripts/`: repository helper scripts.
- `.github/workflows/`: Docker build checks and release publication.
- `.devcontainer/`: optional development container configuration.

Additional tool images can be added under `containers/` independently.

## Build

From the repository root:

```sh
./scripts/build-ghdl.sh
# Optional: choose an image name and tag
./scripts/build-ghdl.sh vhdlivery/fpga-env:1.0
```

## Run the example

```sh
docker run --rm -it -v "$PWD:/workspace" \
  -w /workspace/examples/vhdl fpga-env/ghdl:local bash
```

Then follow [the example instructions](examples/vhdl/README.md).
The project sources are mounted at runtime, not included in the image.

## Checks

Linting does not require a dedicated image yet. GHDL-based checks can use the
GHDL image; other checks can run directly in their respective environments.

## GitHub Actions and releases

Changes to the GHDL Dockerfile, VHDL example, build context exclusions or workflows
trigger native AMD64 and ARM64 build checks on pull requests and pushes to
`main`. Each check verifies GHDL, VUnit and fpgather and runs all three counter
simulation tests inside the image.
The build workflow can also be started manually. Checks never publish images.

Publishing a GitHub release first runs both build and simulation checks, then
builds its tagged commit and uploads a multi-platform
image for Linux AMD64 and ARM64 to `ghcr.io/vhdlivery/fpga-env/ghdl`.
The GitHub release tag becomes the image tag, for example:

```sh
docker pull ghcr.io/vhdlivery/fpga-env/ghdl:v1.0.0
```

Stable releases also update `latest`; prereleases publish only their release
tag. Creating a draft release or pushing a Git tag alone does not publish an
image. Release builds bypass the build cache to resolve the unpinned Python
packages again. Consequently, rebuilding a release can produce different
package versions.

Authentication uses the workflow's automatic `GITHUB_TOKEN`; no personal token
or Docker Hub credentials are needed. Organization settings must allow package
creation. If anonymous pulls are desired, verify that the GHCR package has
public visibility after its first publication.
