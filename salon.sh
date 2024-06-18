#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

# Function to display services
echo -e "\n"
echo "~~~~~ MY SALON ~~~~~"
echo -e "\n"
echo "Welcome to My Salon, how can I help you?"

# Fetch list of services with their IDs
SERVICES_QUERY="$PSQL \"SELECT service_id, name FROM services\""
SERVICES_LIST=$(eval $SERVICES_QUERY)

# Display numbered list of services
echo "$SERVICES_LIST" | while IFS='|' read -r SERVICE_ID SERVICE_NAME; do
    echo "$SERVICE_ID) $SERVICE_NAME"
done

# Prompt for service selection
while true; do
    echo -e "\n"
    read -p "Enter the number of the service you'd like today: " SERVICE_ID_SELECTED

    # Validate if the selected service ID exists in the list
    if echo "$SERVICES_LIST" | cut -d '|' -f 1 | grep -q "^$SERVICE_ID_SELECTED$"; then
        SERVICE_NAME=$(echo "$SERVICES_LIST" | grep "^$SERVICE_ID_SELECTED" | cut -d '|' -f 2)
        break
    else
        echo -e "\n"
        echo "I could not find that service. What would you like today?"
        echo "$SERVICES_LIST" | while IFS='|' read -r SERVICE_ID SERVICE_NAME; do
            echo "$SERVICE_ID) $SERVICE_NAME"
        done
    fi
done

# Prompt for phone number
echo -e "\n"
read -p "What's your phone number? " CUSTOMER_PHONE

# Check if the customer already exists in the database
CUSTOMER_QUERY="$PSQL \"SELECT customer_id, name FROM customers WHERE phone='$CUSTOMER_PHONE'\""
CUSTOMER_INFO=$(eval $CUSTOMER_QUERY)

if [[ -z "$CUSTOMER_INFO" ]]; then
    # If customer does not exist, prompt for name
    echo -e "\n"
    read -p "I don't have a record for that phone number, what's your name? " CUSTOMER_NAME

    # Insert new customer into database
    INSERT_CUSTOMER_QUERY="$PSQL \"INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE') RETURNING customer_id\""
    CUSTOMER_ID=$(eval $INSERT_CUSTOMER_QUERY)
else
    # If customer exists, retrieve customer_id from database
    CUSTOMER_ID=$(echo "$CUSTOMER_INFO" | cut -d '|' -f 1)
    CUSTOMER_NAME=$(echo "$CUSTOMER_INFO" | cut -d '|' -f 2)
fi

# Prompt for appointment time
echo -e "\n"
read -p "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME? " SERVICE_TIME

# Insert appointment into appointments table
INSERT_APPOINTMENT_QUERY="$PSQL \"INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')\""
eval $INSERT_APPOINTMENT_QUERY

# Output confirmation message with proper spacing
echo -e "\n"
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
echo -e "\n"
