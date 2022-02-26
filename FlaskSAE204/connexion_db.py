from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
import pymysql.cursors
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = pymysql.connect(
            host="FerryDupuySchott.mysql.pythonanywhere-services.com",
            # host="serveurmysql",
            user="FerryDupuySchott",
            password="Sae_204mgl",
            database="FerryDupuySchott$BDD_sae204",
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor
        )
    return db
