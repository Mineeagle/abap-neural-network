"! <p class="shorttext synchronized">Basic Layer class</p>
CLASS z_cvqxp_nn_layer DEFINITION PUBLIC ABSTRACT.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Forward through the layer</p>
    "! This method receives and input vector, and calculates the output vector of the layer.
    "! As this is of course completely depending on the layer type at hand, this method needs to be re-implemented for every layer type.
    "! @parameter it_inputs  | <p class="shorttext synchronized">Input vector</p>
    "! @parameter rt_outputs | <p class="shorttext synchronized">Output vector</p>
    METHODS forward ABSTRACT
      IMPORTING it_inputs         TYPE z_cvqxp_nn_types=>list_of_float
      RETURNING VALUE(rt_outputs) TYPE z_cvqxp_nn_types=>list_of_float.

    "! <p class="shorttext synchronized">Backward through the layer</p>
    "! This method receives the error gradient with respect to its layer's output [as well as a learning rate],
    "! and is supposed to return the error with respect to the input. It is supposed to update the weights and biases as well.
    "! As this is of course completely depending on the layer type at hand, this method needs to be re-implemented for every layer type.
    "! @parameter it_output_gradient | <p class="shorttext synchronized">Error with respect to the output</p>
    "! @parameter iv_learning_rate   | <p class="shorttext synchronized">Leaning rate</p>
    "! @parameter rt_new_gradient    | <p class="shorttext synchronized">Error with respect to the input</p>
    METHODS backward ABSTRACT
      IMPORTING it_output_gradient     TYPE z_cvqxp_nn_types=>list_of_float
                iv_learning_rate       TYPE z_cvqxp_nn_types=>float
      RETURNING VALUE(rt_new_gradient) TYPE z_cvqxp_nn_types=>list_of_float.

  PROTECTED SECTION.
    "! When forward is called, inputs are supposed to be stored in here, so that they can be used in the backward method.
    DATA mt_inputs TYPE z_cvqxp_nn_types=>list_of_float.
ENDCLASS.


CLASS z_cvqxp_nn_layer IMPLEMENTATION.
ENDCLASS.