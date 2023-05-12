*** Settings ***
Library             RequestsLibrary


*** Variables ***


*** Keywords ***
GET Endereço
    [Arguments]         ${quantidade}

    Create Session      alias=faker_api     url=https://fakerapi.it/api/v1

    ${RESPONSE}         GET On Session      alias=faker_api     url=/addresses?_quantity=${quantidade}

    Log To Console      ${RESPONSE.json()}

    [Return]            ${RESPONSE}

GET Endereço - Validação Quantidade
    [Arguments]         ${quantidade}       ${GET_RESPONSE}

    ${var}              Set Variable        ${GET_RESPONSE.json()['total']}

    ${var}              Convert To String   ${var}
    
    Should Be Equal     ${var}              ${quantidade}


GET Endereço - Validação Localização
    [Arguments]         ${quantidade}       ${GET_RESPONSE}

    ${var}              Set Variable        ${GET_RESPONSE.json()['data']}


    FOR  ${i}  IN RANGE  ${quantidade}
        Log To Console  **** Elemento número ${i} ****

        ${latitude}     Set Variable    ${GET_RESPONSE.json()['data'][${i}]['latitude']}
        ${longitude}    Set Variable   ${GET_RESPONSE.json()['data'][${i}]['longitude']}
        ${country}    Set Variable   ${GET_RESPONSE.json()['data'][${i}]['country']}

        # Validaçao latitude
        ${resp_latitude}    Validação Latitude  ${latitude}

        # Validaçao longitude
        ${resp_longitude}    Validação longitude  ${longitude}


        Log To Console      ${resp_latitude} - ${resp_longitude} - ${country}

    END 


Validação Latitude  
    [Arguments]         ${latitude}

    IF  ${latitude}>0
        # log to console Hemisfério Norte
        ${Return}       Set Variable        Hemisfério Norte
    ELSE IF     ${latitude}<0
        # log to console Hemisfério Sul
        ${Return}       Set Variable        Hemisfério Sul
    ELSE
        # log to console Em cima da linha do Equoador
        ${Return}       Set Variable        Em cima da linha do Equoador
    END

    [Return]    ${Return}


Validação longitude  
    [Arguments]         ${longitude}  

    IF  ${longitude}>0
        # log to console Hemisfério Oriental
        ${Return}       Set Variable        Hemisfério Oriental
    ELSE IF     ${longitude}<0
        # log to console Hemisfério Ocidental
        ${Return}       Set Variable        Hemisfério Ocidental
    ELSE
        # log to console Em cima do meridiano de Greenwich
        ${Return}       Set Variable        Em cima do meridiano de Greenwich
    END

    [Return]    ${Return}