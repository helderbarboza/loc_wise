# LocWise

Location Management and Data Visualization.

## Usage

Here you can choose one of these options to prepare your environment.

<details>
<summary>Using Docker</summary>
<p>
You can run this application on a Docker container, to do this you will need to 
have Docker installed on your machine.

* Start a container with `docker-compose up -d`
</p>
</details>

<details>
<summary>Using asdf</summary>
<p>
You can also use <a href="https://asdf-vm.com/">asdf</a> if you have it installed.

To install all necessary tools, simply run `asdf install`.
</p>
</details>

If you managed to prepare the environment, follow the next steps:

  * Run `mix setup` to install, setup dependencies and initialize the database
  * Run tests using `mix test`
  * Start the server with `mix phx.server`, once it is done go to http://localhost:4000 