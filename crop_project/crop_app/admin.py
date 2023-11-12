# pond_app/admin.py
from django.contrib import admin
from .models import CustomUser, CropData

admin.site.register(CustomUser)
admin.site.register(CropData)
