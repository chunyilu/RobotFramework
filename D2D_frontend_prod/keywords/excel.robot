*** Keywords ***

Get Sheet Values Per Sheet
    [Arguments]  ${excel_path}  ${sheet_name}  ${column_from}  ${column_to}
    Open Excel  ${excel_path}
    ${sheet_dict}=  Create Dictionary
    ${count}=  Evaluate  ${column_to}+1
    :FOR  ${i}  IN RANGE  ${column_from}  ${count}
    \  ${column}=  Read Cell Data By Coordinates  Positive  ${i}  ${column_from}
    \  ${column_values}=  Get Column Values  Positive  ${i}
    \  ${tmp}=  Create Column List  ${column}  ${column_values}
    \  Set To Dictionary  ${sheet_dict}  ${column}  ${tmp}
    [Return]  ${sheet_dict}

Create Column List
    [Arguments]  ${column_name}  ${column_values}
    ${count}=  Get Length  ${column_values}
    ${tmp}=  Create List
    :FOR  ${j}  IN RANGE  1  ${count}
    \  ${column_value}=  Convert To String  ${column_values[${j}][1]}
    \  ${column_value}=  Replace String  ${column_value}  .0  ${EMPTY}
    \  Append To List  ${tmp}  ${column_value}
    [Return]  ${tmp}

Get All Values Per File
    [Arguments]  ${excel_path}
    Open Excel  ${excel_path}
    ${sheets}=  Get Sheet Names
    ${count}=  Get Length  ${sheets}
    ${sheet_values}=  Create List
    :FOR  ${i}  IN RANGE  0  ${count}
    \  ${sheet}=  Get Sheet Values  ${sheets[${i}]}
    \  Append To List  ${sheet_values}  ${sheet}
    [Return]  ${sheet_values}