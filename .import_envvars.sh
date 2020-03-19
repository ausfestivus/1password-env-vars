#!/usr/bin/env bash

TENANT_ID="XXXXXXXX"

# Login to 1Password.
# Assumes you have installed the OP CLI and performed the initial configuration
# For more details see https://support.1password.com/command-line-getting-started/
eval "$(op signin ${TENANT_ID})"

# put our search string into a var
string="${1}"

# build a filter we can use to output our list of items that match.
#filter=".[] | .overview.title as \$t | select(\$t | index(\"${string}\")) | [\$t, .uuid] | @csv"
filter=".[] | .overview.title as \$t | select(\$t | index(\"${string}\")) | [\$t, .uuid] | @csv"

# create our empty associative array.
declare -A myitems

# prepare to read in in our key and value pairs from the op output
while IFS="," read -r key value
do
    # now we need to lose the preceding and trailing double-quotes (") from our VARs
    key="${key%\"}"
    key="${key#\"}"

    value="${value%\"}"
    value="${value#\"}"
    myitems[$key]="$value"
done < <(op list items | jq -r -c "${filter}")

# DEBUG display the list of entries we stored in the array
#echo ""
#echo "[DEBUG] - Step through associative array elements and display them."
#for key in "${!myitems[@]}"
#do
#    echo "[DEBUG] - \"$key\" = \"${myitems[$key]}\""
#done
#echo ""

# now we create and present the operator with a list of choices to select the env var they're wanting.
echo "Please select an entry:"
select key in "${!myitems[@]}"; do
  [[ -n ${key} ]] || { echo "Invalid choice. Please try again." >&2; continue; }
  break # valid choice was made; exit prompt.
done

# uncomment if debugging.
#echo ""
#echo "[DEBUG] - The following item was selected."
#echo "[DEBUG] - title: [$key]; uuid: [${myitems[$key]}]"
#echo ""

# Now that the ops has selected the record we're interested in, lets pull the item
ev=`op get item ${myitems[$key]}`

# Convert to base64 for multi-line secrets.
# The schema for the 1Password type 'Password' uses t as the label, and v as the value.
for row in $(echo ${ev} | jq -r -c '.details.sections[1].fields[] | @base64'); do
    _envvars() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    echo "Setting environment variable $(_envvars '.t')"
    export $(echo "$(_envvars '.t')=$(_envvars '.v')")
done
