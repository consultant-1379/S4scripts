curl --insecure -X GET "https://atvdit.athtem.eei.ericsson.se/api/documents/601d744368295e36b3bac44a" -H "accept: application/json" | python -m json.tool > dit_integration.json

cat dit_integration.json | grep -v "__v\|601d744368295e36b3bac44a\|autopopulate\|content\|created_at\|managedconfig\|ieatenmc15a014_integration_value_file\|schema_id\|updated_at" > dit_integration.json.processed

##curl --insecure -X GET "https://atvdit.athtem.eei.ericsson.se/api/documents/601d744368295e36b3bac44a" -H "accept: application/json" > dit_integration.json

##cat dit_integration.json | grep -o -P '(?<=content":).*(?=},"name)' | python -m json.tool

#cat dit_integration.json | grep -o -P '(?<=content).*(?=created_at)'


#echo "Here is a string" | grep -o -P '(?<=Here).*(?=string)'


#echo "Here is a string" | grep -o -P '(?<=content).*(?=persistence)'

sed -e 's/{//g' -e 's/}//g' -e 's/,//g' -e 's/"//g' dit_integration.json.processed > dit_integration.json.processed.cleaned

#removes blank lines
sed '/^ *$/d' dit_integration.json.processed.cleaned > dit_integration.json.processed.cleaned.noblanks
#sed '/^$/d' dit_integration.json.processed.cleaned > dit_integration.json.processed.cleaned.noblanks

cat dit_integration.json.processed.cleaned.noblanks | cut -c 9- > dit_integration.json.processed.cleaned.cut

