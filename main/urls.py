from django.urls import path
from main import views

urlpatterns = {
    path('test/', views.test, name='test'),
    path('test.html', views.test),
    path('', views.test, name='test'),
}