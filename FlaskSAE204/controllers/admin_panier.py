#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint

admin_panier = Blueprint('admin_panier', __name__,
                        template_folder='templates')