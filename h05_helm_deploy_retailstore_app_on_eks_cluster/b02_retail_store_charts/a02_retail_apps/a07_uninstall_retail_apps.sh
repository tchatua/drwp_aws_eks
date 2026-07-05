#!/bin/bash

echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo "Starting Helm uninstalls for Retail Store Sample App..."
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo

# Step 05 - UI Service
echo "--------------------------------------------"
echo "Uninstalling UI Service..."
echo "--------------------------------------------"
echo
helm uninstall ui
sleep 10

# Step 04 - Orders Service
echo "--------------------------------------------"
echo "Uninstalling Orders Service..."
echo "--------------------------------------------"
echo
helm uninstall orders
sleep 10

# Step 03 - Checkout Service
echo "--------------------------------------------"
echo "Uninstalling Checkout Service..."
echo "--------------------------------------------"
echo
helm uninstall checkout
sleep 10

# Step 02 - Cart Service
echo "--------------------------------------------"
echo "Uninstalling Cart Service..."
echo "--------------------------------------------"
helm uninstall cart
echo
sleep 10

# Step 01 - Catalog Service
echo "--------------------------------------------"
echo "Uninstalling Catalog Service..."
echo "--------------------------------------------"
helm uninstall catalog
echo
sleep 10

echo
echo "--------------------------------------------"
echo "All Helm uninstalls completed!"
echo "--------------------------------------------"
echo
