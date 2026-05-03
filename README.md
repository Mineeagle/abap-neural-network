# abap-neural-network

This repository contains a neural network implemented completely in ABAP, which can be used and repurposed for your own needs.

The source code and maths behind this implementation is based on explanations and the python code of [this](https://www.youtube.com/watch?v=pauPCy_s0Ok) video. If you are interested in the maths and logic behind neural networks, have a look at it. This will improve your understanding of this implementation drastically.

- [abap-neural-network](#abap-neural-network)
- [Classes and contents](#classes-and-contents)
- [Usage](#usage)
- [Example](#example)
  - [Wrapper class](#wrapper-class)
  - [Main class](#main-class)
- [Conclusion](#conclusion)

# Classes and contents

This repository contains, to be more specific, a [dense layer](src/layers/z_cvqxp_nn_layer_dense.clas.abap) and three different activation layers ([ReLU](src/layers/z_cvqxp_nn_layer_act_relu.clas.abap), [TanH](src/layers/z_cvqxp_nn_layer_act_tanh.clas.abap), and [Sigmoid](src/layers/z_cvqxp_nn_layer_act_sigmoid.clas.abap)).

Additionally, a [neural network](src/z_cvqxp_neural_network.clas.abap) class exists as well, which sort of wraps around multiple layers, providing easy access to pass data forward and backward through the different layers. 

For more information on how to use the implementation, please [continue](#usage) to read along, or have a look at the [example](#example) in the [example](./example/) folder.

# Usage

In order to use the neural network a new class can be created, which inherits from class [z_cvqxp_neural_network](src/z_cvqxp_neural_network.clas.abap):

This class then receives may use the super constructor of class `z_cvqxp_nn_neural_network` and it also may use two methods called `_train` and `_predict`, which are used to either predict using the model, or train the model. This created class is supposed to be an intermediate layer between user input and neural network, translation user input into decimal numbers and neural network output back into the dezired format.

# Example

In order to understand how this implementation can be used, let's have a look at the [example folder](./example/). To be more precise, let's first look at the [z_cvqxp_nn_xor_wrapper](example/z_cvqxp_nn_xor_wrapper.clas.abap) class.

## Wrapper class

As the name suggests, this class is a wrapper build on top of the neural network, used to train and predict the [XOR](https://en.wikipedia.org/wiki/Exclusive_or) operation.

It has the following public `predict` method:

```abap
    "! <p class="shorttext synchronized">Make a prediction for XOR</p>
    "! This method makes a prediction, using the neural network, for XOR.
    "! @parameter iv_boolean_1       | <p class="shorttext synchronized">Boolean input one</p>
    "! @parameter iv_boolean_2       | <p class="shorttext synchronized">Boolean input two</p>
    "! @parameter rv_predicted_value | <p class="shorttext synchronized">Prediction of the neural network</p>
    METHODS predict
      IMPORTING iv_boolean_1              TYPE abap_bool
                iv_boolean_2              TYPE abap_bool
      RETURNING VALUE(rv_predicted_value) TYPE abap_bool.

...

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
```

As you can see, the predict method does three things:

1. Convert the inputs values (two booleans) into floats
2. Call the `_predict` method of the underlying neural network to predict to pass the calculated input vector through the neural network
3. Convert the received output vector into a boolean, so that it matches what the user wants to recieve

(In OO-fashion, it might be better to split this method up into several more, as this method has mutliple purposes - nonetheless, I did refrain from it to keep the class more lenient.)

This `predict` method, which wraps around `_predict` method of the neural network, allows to simply interact with it, without the need to translate importing / exporting parameters and returning values constantly:

```abap
    DATA(lv_prediction) = lo_neural_network->predict( iv_boolean_1 = abap_false
                                                      iv_boolean_2 = abap_false ).
```

As this example from class [z_cvqxp_nn_main](example/z_cvqxp_nn_main.clas.abap) shows, this makes calling and using the neural network being almost trivial.

The train method works, using the same principal:

1. Encode the input values into an input vector using only numbers
2. Do the same for the expected outputs
3. Execute the `_train` method of the neural network.

Hence, a simple statement like this already suffices to train the network:

```abap
lo_neural_network->train( iv_boolean_1      = abap_false
                                iv_boolean_2      = abap_false
                                iv_expected_value = abap_false ).
```

## Main class

With the wrapper class in hand, the only question left is how to instantiate the neural network. For this, let's look at the main class [z_cvqxp_nn_main](example/z_cvqxp_nn_main.clas.abap).

```abap
    DATA(lv_learning_rate) = CONV z_cvqxp_nn_types=>float( '0.01' ).
    ...
    DATA(lo_neural_network) = NEW z_cvqxp_nn_xor_wrapper(
                                      it_layers        = VALUE z_cvqxp_nn_neural_network=>ty_neural_network(
                                                                   ( NEW
                                                                     z_cvqxp_nn_layer_dense( iv_inputs_amt  = 2
                                                                                             iv_outputs_amt = 3 ) )
                                                                   ( NEW z_cvqxp_nn_layer_act_relu( ) )
                                                                   ( NEW
                                                                     z_cvqxp_nn_layer_dense( iv_inputs_amt  = 3
                                                                                             iv_outputs_amt = 1 ) )
                                                                   ( NEW z_cvqxp_nn_layer_act_sigmoid( ) ) )
                                      iv_learning_rate = lv_learning_rate ).
```

This is, how the neural network (`lo_neural_network`) can be instantiated. Simply provide an internal table of all the layers you'd like to use, as well as a learning rate, and instatiate your wrapper class. It is important to note, that the number of inputs of the first layer **must** be equal to the dimensions of the information vector encoded by your neural network. Similarly, the number of outputs **must** be equal to the dimensions, your wrapper class requires for the decoding.

Afterwards, the instance can simply be used to predict and train the network as explained in the [prior section](#wrapper-class).

# Conclusion

Feel free to use the code in this repository however you like. Just please bear in mind that it may contain errors, and is certainly not the most efficient implementation.
