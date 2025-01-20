import os
import unittest
from flask import Flask
from your_flask_app import app  # Replace 'your_flask_app' with the name of your Python file without the .py extension

class FlaskAppTests(unittest.TestCase):
    def setUp(self):
        # Set up the Flask test client
        self.app = app.test_client()
        self.app.testing = True

        # Set environment variables for testing
        os.environ['DB_HOST'] = 'localhost'
        os.environ['DB_USER'] = 'root'
        os.environ['DB_PASSWORD'] = 'password'
        os.environ['DB_DATABASE'] = 'todo_db'

    def test_index(self):
        # Test the index route
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<!DOCTYPE html>', response.data)  # Check for HTML content

    def test_add_task(self):
        # Test adding a task
        response = self.app.post('/add', data={'title': 'Test Task', 'description': 'Test Description'})
        self.assertEqual(response.status_code, 302)  # Check for redirect
        self.assertEqual(response.location, 'http://localhost/')  # Check redirect location

    def test_delete_task(self):
        # Test deleting a task (assuming task with ID 1 exists)
        response = self.app.post('/delete/1')
        self.assertEqual(response.status_code, 302)  # Check for redirect
        self.assertEqual(response.location, 'http://localhost/')  # Check redirect location

    def test_complete_task(self):
        # Test completing a task (assuming task with ID 1 exists)
        response = self.app.post('/complete/1')
        self.assertEqual(response.status_code, 302)  # Check for redirect
        self.assertEqual(response.location, 'http://localhost/')  # Check redirect location

if __name__ == '__main__':
    unittest.main()