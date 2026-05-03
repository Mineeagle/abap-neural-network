"! <p class="shorttext synchronized">XOR wrapper for the neural network</p>
"! This call serves as an abstraction layer between the neural network and the user. It takes iput values by the user,
"! converts them into vectors, and passes them on to the neural network.
"! This process also happens the other way around.
CLASS z_cvqxp_nn_xor_wrapper DEFINITION
  PUBLIC
  INHERITING FROM z_cvqxp_nn_neural_network
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Make a prediction for XOR</p>
    "! This method makes a prediction, using the neural network, for XOR.
    "! @parameter iv_boolean_1       | <p class="shorttext synchronized">Boolean input one</p>
    "! @parameter iv_boolean_2       | <p class="shorttext synchronized">Boolean input two</p>
    "! @parameter rv_predicted_value | <p class="shorttext synchronized">Prediction of the neural network</p>
    METHODS predict
      IMPORTING iv_boolean_1              TYPE abap_bool
                iv_boolean_2              TYPE abap_bool
      RETURNING VALUE(rv_predicted_value) TYPE abap_bool.

    "! <p class="shorttext synchronized">Train the neural network</p>
    "! Train the neural network, based on the parameters provided for XOR.
    "! @parameter iv_boolean_1          | <p class="shorttext synchronized">Boolean input one</p>
    "! @parameter iv_boolean_2          | <p class="shorttext synchronized">Boolean input two</p>
    "! @parameter iv_expected_value     | <p class="shorttext synchronized">Expected output boolean</p>
    "! @parameter rv_mean_squared_error | <p class="shorttext synchronized">Mean squared error</p>
    METHODS train
      IMPORTING iv_boolean_1                 TYPE abap_bool
                iv_boolean_2                 TYPE abap_bool
                iv_expected_value            TYPE abap_bool
      RETURNING VALUE(rv_mean_squared_error) TYPE z_cvqxp_nn_types=>float.
ENDCLASS.


CLASS z_cvqxp_nn_xor_wrapper IMPLEMENTATION.
  METHOD train.
    " Convert the inputs into decimals
    DATA(lt_input_vector) = VALUE z_cvqxp_nn_types=>list_of_float(
                                      ( COND #( WHEN iv_boolean_1 = abap_true THEN '1' ELSE '0' ) )
                                      ( COND #( WHEN iv_boolean_2 = abap_true THEN '1' ELSE '0' ) ) ).
    " Convert the expected output into decimals
    DATA(lt_expected_output) = VALUE z_cvqxp_nn_types=>list_of_float(
                                         ( COND #( WHEN iv_expected_value = abap_true THEN '1' ELSE '0' ) ) ).

    " Train using the converted values
    RETURN _train( it_input_values    = lt_input_vector
                   it_expected_values = lt_expected_output ).
  ENDMETHOD.

  METHOD predict.
    " Convert the inputs into decimals
    DATA(lt_input_vector) = VALUE z_cvqxp_nn_types=>list_of_float(
                                      ( COND #( WHEN iv_boolean_1 = abap_true THEN '1' ELSE '0' ) )
                                      ( COND #( WHEN iv_boolean_2 = abap_true THEN '1' ELSE '0' ) ) ).
    " Predict
    DATA(lt_output_vector) = _predict( it_input_values = lt_input_vector ).

    " Convert the prediction
    RETURN xsdbool( lt_output_vector[ 1 ] >= '0.5' ).
  ENDMETHOD.
ENDCLASS.