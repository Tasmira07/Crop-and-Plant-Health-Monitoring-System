from rest_framework import generics, permissions
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from django.contrib.auth import get_user_model
from .models import CropData
from .serializers import CropDataSerializer, UserSerializer

CustomUser = get_user_model()

class UserRegistrationView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = UserSerializer
    permission_classes = (permissions.AllowAny,)

class CropDataListCreateView(generics.ListCreateAPIView):
    serializer_class = CropDataSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return CropData.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class CropDataDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CropData.objects.all()
    serializer_class = CropDataSerializer
    permission_classes = (permissions.IsAuthenticated,)

class UserTokenObtainPairView(TokenObtainPairView):
    pass

class UserTokenRefreshView(TokenRefreshView):
    pass
