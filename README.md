# mori-san
I like to eat Scallops at Mori Teppan Grill!

Frontend client [in Godot](https://github.com/buddha314/mori-client-godot)

## Checkout
As this project uses submodules, you will need to clone with the `--recursive` flag or run the following commands after cloning.
```bash
git clone git@github.com:buddha314/mori-san.git
cd mori-san
git submodule update --init --recursive
```

## Update submodules
```bash
git submodule update --recursive --remote
```

## Running

Run within the docker container with the command

```bash
poetry run python app/main.py 
```

Don't forget to run this if you have to update the dependencies

```bash
poetry install --no-interaction --no-ansi --no-root
```

To add a new dependency, run

```bash
poetry add <package>
```
