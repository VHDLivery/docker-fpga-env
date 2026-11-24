# docker-fpga-env

Development environments combining independently published FPGA tool images.

## Open Source environment

The environment currently provides GHDL, VUnit, fpgather and GTKWave through
`ghcr.io/vhdlivery/docker-ghdl:latest`. Yosys is not included yet.
The image source, tests and release workflows live in
[VHDLivery/docker-ghdl](https://github.com/VHDLivery/docker-ghdl).
No Git submodules or local tool builds are required.

The GHDL image must be published from that repository before the default
configuration can be started. For reproducible environments, choose a published
version tag or digest rather than `latest`.

## VS Code

Install Docker and the VS Code Dev Containers extension. Open this repository
and select **Dev Containers: Reopen in Container** from the Command Palette.
Select **Open Source – GHDL** if prompted.

The configuration in `.devcontainer/opensource/devcontainer.json` connects to
the Compose service `ghdl`. The repository is mounted at `/workspace`.
TerosHDL, Python and Python Debugger are installed as editor extensions.
The container user is `fpga-env`, and Python uses its virtual environment.
Closing the development container stops the Compose environment.

To choose a version, set `GHDL_IMAGE` in your host environment before starting
VS Code, or edit the Compose image reference. For example, after publishing
that release:

```sh
export GHDL_IMAGE=ghcr.io/vhdlivery/docker-ghdl:v1.0.0
code .
```

## Without VS Code

```sh
docker compose -f .devcontainer/opensource/compose.yaml run --rm ghdl bash
```

The current repository is the mounted workspace. The container supplies tools;
it does not include a copy of your project. Simulation outputs should use
`build/ghdl/` within the project. For examples and container tests, see the
GHDL image repository.

## Additional tools

Add an independent service to `.devcontainer/opensource/compose.yaml` for a
future tool such as Yosys. Mount the same workspace at `/workspace` and keep
its generated output separate, for example `build/yosys/`. Tool processes run
independently; no source repository checkout is required for their images.

GitHub Actions validates the environment configuration here. Tool image builds,
simulation tests and image releases belong to the respective tool repository.
