import click
from flask.cli import with_appcontext

from database import db
import models

@click.command(name='create_tables')
@with_appcontext
def create_tables():
    db.create_all()