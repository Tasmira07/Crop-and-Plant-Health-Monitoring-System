from django.urls import path
from .views import UserRegistrationView, CropDataListCreateView, CropDataDetailView, UserTokenObtainPairView, UserTokenRefreshView

urlpatterns = [
    path('register/', UserRegistrationView.as_view(), name='user-registration'),
    path('data/', CropDataListCreateView.as_view(), name='crop-data-list-create'),
    path('data/<int:pk>/', CropDataDetailView.as_view(), name='crop-data-detail'),
    path('token/', UserTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', UserTokenRefreshView.as_view(), name='token_refresh'),
]
