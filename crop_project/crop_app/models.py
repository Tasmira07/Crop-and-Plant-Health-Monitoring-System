from django.db import models
from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    pass

class CropData(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    temperature = models.FloatField()
    humidity = models.FloatField()
    moisture = models.FloatField()
