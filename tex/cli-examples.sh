# Show the help message and exits with 0.
fdtd-lucuma --help

# Open the GUI
fdtd-lucuma -g

# Run a single headless simulation in a 100^3 cube using only one cpu thread and with 32 bits of precision for 1000 time steps
fdtd-lucuma -x 100 -y 100 -z 100 -b sequential -p f32 -t 1000

# Run one or more headless simulations
fdtd-lucuma simulation-parameters.json