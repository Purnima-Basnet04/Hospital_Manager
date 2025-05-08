#!/bin/bash

# Find all JSP files in the patient directory
for file in $(find src/main/webapp/patient -name "*.jsp"); do
  # Skip the billing.jsp file itself
  if [[ "$file" != "src/main/webapp/patient/billing.jsp" ]]; then
    # Remove the billing link from the sidebar
    sed -i '' 's/<li><a href="billing"><i class="fas fa-file-invoice-dollar"><\/i> Billing<\/a><\/li>//g' "$file"
  fi
done

echo "Billing links removed from all patient JSP files."
