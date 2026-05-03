"! <p class="shorttext synchronized">Implementation of MSE</p>
CLASS z_cvqxp_nn_error DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Get the means squared error</p>
    "! This method return the means squared error for a given output and an expected output.
    "! <br>
    "! The MSE is the average of the difference between expected output and actual output squared.
    "! @parameter it_expected_values    | <p class="shorttext synchronized">List of expected output</p>
    "! @parameter it_predicted_values   | <p class="shorttext synchronized">List of predicted outputs</p>
    "! @parameter rv_mean_squared_error | <p class="shorttext synchronized">The calculated MSE</p>
    CLASS-METHODS mean_squared_error
      IMPORTING it_expected_values           TYPE z_cvqxp_nn_types=>list_of_float
                it_predicted_values          TYPE z_cvqxp_nn_types=>list_of_float
      RETURNING VALUE(rv_mean_squared_error) TYPE z_cvqxp_nn_types=>float.

    "! <p class="shorttext synchronized">Return the MSE gradient</p>
    "! This method returns the gradient, in order to quantify how much the respective output value does not match the expectation.
    "! <br>
    "! The gradient is the error of the output with respect to itself, compared against the actual output.
    "! For each expected output and actual output pair, the gradient factor can be calculated by multiplying the difference between
    "! both by two, and dividing by the number of expected output values.
    "! @parameter it_expected_values  | <p class="shorttext synchronized">List of expected output</p>
    "! @parameter it_predicted_values | <p class="shorttext synchronized">List of predicted outputs</p>
    "! @parameter rt_mse_gradient     | <p class="shorttext synchronized">Error vector with respect to the output</p>
    CLASS-METHODS mean_squared_error_gradient
      IMPORTING it_expected_values     TYPE z_cvqxp_nn_types=>list_of_float
                it_predicted_values    TYPE z_cvqxp_nn_types=>list_of_float
      RETURNING VALUE(rt_mse_gradient) TYPE z_cvqxp_nn_types=>list_of_float.
ENDCLASS.


CLASS z_cvqxp_nn_error IMPLEMENTATION.
  METHOD mean_squared_error.
    " Sum up all the squared differences
    DO lines( it_expected_values ) TIMES.
      rv_mean_squared_error += ( it_expected_values[ sy-index ] - it_predicted_values[ sy-index ] ) ** 2.
    ENDDO.
    " Divide by the number of expected outputs, in order to get the averade
    rv_mean_squared_error /= lines( it_expected_values ).
  ENDMETHOD.

  METHOD mean_squared_error_gradient.
    DO lines( it_predicted_values ) TIMES.
      APPEND ( it_predicted_values[ sy-index ] - it_expected_values[ sy-index ] ) * ( 2 / lines( it_predicted_values ) ) TO rt_mse_gradient.
    ENDDO.
  ENDMETHOD.
ENDCLASS.