%% Backward Propagation

function [ updatedModel ] = backwardProp( model, learning_rate, input, hidden_output, prediction, label )
    updatedModel = model;
    deltaOut = -(label-prediction) .* prediction .* (1-prediction);
    [updatedModel.out_weight, updatedModel.out_bias] = backward(model.out_weight, model.out_bias, learning_rate, hidden_output, deltaOut);
    [updatedModel.in_weight, updatedModel.in_bias] =  inBackProp(model, deltaOut, learning_rate, input, hidden_output);
end

function [ weightUpdated, biasUpdated ] = backward( weight, bias, learningRate, input, delta )
    num_input = size(input, 1);
    input_with_bias = [input ones(num_input,1)];
    weight_bias = [weight; bias];
    updated_weight_bias = weight_bias-(learningRate/num_input)*input_with_bias'*delta;
    weightUpdated = updated_weight_bias(1:end-1, :);
    biasUpdated = updated_weight_bias(end, :);
end

function [ updated_weight, updated_bias ] = inBackProp( model, deltaOut, learningRate, input, hiddenOut )
    hidden_output_bias = [hiddenOut ones(size(hiddenOut, 1),1)];
    out_weight_bias = [model.out_weight; model.out_bias];
    in_delta = (deltaOut*out_weight_bias').*hidden_output_bias.*(1-hidden_output_bias);
    
    input_with_bias = [input ones(size(input, 1),1)];
    old_weight_bias = [model.in_weight; model.in_bias];
    new_weight_bias = zeros(size(old_weight_bias));
    num_input = size(input_with_bias, 1);
    for i=1:size(old_weight_bias, 1)
        for j=1:size(old_weight_bias, 2)
            new_weight_bias(i, j) = old_weight_bias(i, j)-(learningRate/num_input)*in_delta(:,j)'*input_with_bias(:,i);
        end
    end
    updated_weight = new_weight_bias(1:end-1, :);
    updated_bias = new_weight_bias(end, :);
end
