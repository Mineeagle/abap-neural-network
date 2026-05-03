"! <p class="shorttext synchronized">Sigmoid activation layer</p>
CLASS z_cvqxp_nn_layer_act_sigmoid DEFINITION
  PUBLIC
  INHERITING FROM z_cvqxp_nn_layer_activate FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS forward REDEFINITION.

  PROTECTED SECTION.
    METHODS activation         REDEFINITION.
    METHODS activation_inverse REDEFINITION.

  PRIVATE SECTION.
    "! Cache for the last sigmoid values calculated
    DATA mt_last_sigmoid_values TYPE z_cvqxp_nn_types=>list_of_float.
ENDCLASS.


CLASS z_cvqxp_nn_layer_act_sigmoid IMPLEMENTATION.
  METHOD forward.
    " Clear the cache, so that only the most recent values are used in the backward method
    CLEAR mt_last_sigmoid_values.
    " Call the usual forward method
    rt_outputs = super->forward( it_inputs = it_inputs ).
  ENDMETHOD.

  METHOD activation.
    " Calculate the sigmoid value
    rv_output_value = 1 / ( 1 + ( exp( - iv_input_value ) ) ).
    " Store the sigmoid value in a cache, as it facilitates the calculation of the inverse
    APPEND rv_output_value TO mt_last_sigmoid_values.
  ENDMETHOD.

  METHOD activation_inverse.
    " Calculate the inverse of the sigmoid, using the cached values
    rv_output_value = mt_last_sigmoid_values[ 1 ] * ( 1 - mt_last_sigmoid_values[ 1 ] ).
    " Delete the value from the cache
    DELETE mt_last_sigmoid_values INDEX 1.
  ENDMETHOD.
ENDCLASS.