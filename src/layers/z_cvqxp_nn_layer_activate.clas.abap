"! <p class="shorttext synchronized">Activation layer class</p>
CLASS z_cvqxp_nn_layer_activate DEFINITION
  PUBLIC
  INHERITING FROM z_cvqxp_nn_layer ABSTRACT
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS forward  REDEFINITION.
    METHODS backward REDEFINITION.

  PROTECTED SECTION.
    "! <p class="shorttext synchronized">Activation function</p>
    "! The activation method used in the activation respective activation layer type.
    "! @parameter iv_input_value  | <p class="shorttext synchronized">Input value</p>
    "! @parameter rv_output_value | <p class="shorttext synchronized">Output of the activation function</p>
    METHODS activation ABSTRACT
      IMPORTING iv_input_value         TYPE Z_cvqxp_nn_types=>float
      RETURNING VALUE(rv_output_value) TYPE Z_cvqxp_nn_types=>float.

    "! <p class="shorttext synchronized">Inverse of the activation function</p>
    "! Return the error with respect to the input
    "! @parameter iv_input_value  | <p class="shorttext synchronized">Error with respect to the output</p>
    "! @parameter rv_output_value | <p class="shorttext synchronized">Error with respect to the input</p>
    METHODS activation_inverse ABSTRACT
      IMPORTING iv_input_value         TYPE Z_cvqxp_nn_types=>float
      RETURNING VALUE(rv_output_value) TYPE Z_cvqxp_nn_types=>float.

ENDCLASS.


CLASS z_cvqxp_nn_layer_activate IMPLEMENTATION.
  METHOD forward.
    " Store the inüuts
    mt_inputs = it_inputs.
    LOOP AT it_inputs ASSIGNING FIELD-SYMBOL(<lv_input>).
      " _Activate_ the inputs
      APPEND activation( <lv_input> ) TO rt_outputs.
    ENDLOOP.
  ENDMETHOD.

  METHOD backward.
    DO lines( it_output_gradient ) TIMES.
      " Calculate the error with respect to the input
      APPEND it_output_gradient[ sy-index ] * activation_inverse( mt_inputs[ sy-index ] ) TO rt_new_gradient.
    ENDDO.
  ENDMETHOD.
ENDCLASS.