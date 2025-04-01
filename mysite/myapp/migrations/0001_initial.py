# Generated by Django 4.0.6 on 2024-12-22 11:50

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Transaction',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('operation', models.CharField(choices=[('buy', 'Покупка'), ('sell', 'Продажа')], max_length=10)),
                ('currency', models.CharField(max_length=10)),
                ('quantity', models.IntegerField()),
                ('rate', models.FloatField()),
                ('date', models.DateTimeField(auto_now_add=True)),
            ],
        ),
    ]
