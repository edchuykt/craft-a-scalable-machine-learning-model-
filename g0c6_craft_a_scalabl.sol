pragma solidity ^0.8.0;

contract ScalableMachineLearningModelMonitor {
    // Mapping of model ids to their respective model details
    mapping (bytes32 => Model) public models;

    // Event emitted when a new model is registered
    event NewModelRegistered(bytes32 modelId, address owner);

    // Event emitted when a model is updated
    event ModelUpdated(bytes32 modelId, address owner);

    // Event emitted when a model's performance is updated
    event ModelPerformanceUpdated(bytes32 modelId, uint256 accuracy, uint256 loss);

    // Struct to represent a machine learning model
    struct Model {
        address owner;
        string name;
        string description;
        bytes32[] features; // List of feature names
        bytes32[] targets; // List of target variable names
        uint256 accuracy; // Current accuracy of the model
        uint256 loss; // Current loss of the model
    }

    // Function to register a new machine learning model
    function registerModel(bytes32 modelId, string calldata name, string calldata description, bytes32[] calldata features, bytes32[] calldata targets) public {
        models[modelId] = Model(msg.sender, name, description, features, targets, 0, 0);
        emit NewModelRegistered(modelId, msg.sender);
    }

    // Function to update a machine learning model
    function updateModel(bytes32 modelId, string calldata name, string calldata description) public {
        require(models[modelId].owner == msg.sender, "Only the owner can update the model");
        models[modelId].name = name;
        models[modelId].description = description;
        emit ModelUpdated(modelId, msg.sender);
    }

    // Function to update a model's performance
    function updateModelPerformance(bytes32 modelId, uint256 accuracy, uint256 loss) public {
        require(models[modelId].owner == msg.sender, "Only the owner can update the model's performance");
        models[modelId].accuracy = accuracy;
        models[modelId].loss = loss;
        emit ModelPerformanceUpdated(modelId, accuracy, loss);
    }

    // Function to get a model's details
    function getModelDetails(bytes32 modelId) public view returns (address, string memory, string memory, bytes32[] memory, bytes32[] memory, uint256, uint256) {
        Model storage model = models[modelId];
        return (model.owner, model.name, model.description, model.features, model.targets, model.accuracy, model.loss);
    }
}