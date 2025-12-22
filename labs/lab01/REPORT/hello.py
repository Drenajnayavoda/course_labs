import typer

# Updated code style (PEP8 formatting)
def main(
    name: str,
    lastname: str = typer.Option("", help="User lastname."),
    formal: bool = typer.Option(False, "--formal", "-f", help="Use formal greeting."),
):
    """Greets the user."""
    if formal:
        print(f"Good day, {name} {lastname}!")
    else:
        print(f"Hello, {name}!")

if __name__ == "__main__":
    typer.run(main)

# Комментарий: изменение комментария
