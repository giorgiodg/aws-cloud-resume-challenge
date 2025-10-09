import { DynamoDBClient, GetItemCommand } from "@aws-sdk/client-dynamodb";
import { unmarshall } from "@aws-sdk/util-dynamodb";
import { UpdateItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: "eu-west-3" });
const TABLE_NAME = "giorgiodg-cloud-resume-challenge";

export const handler = async (event) => {
  try {
    const getCommand = new GetItemCommand({
      TableName: TABLE_NAME,
      Key: {
        id: { S: "1" },
      },
    });

    const getResponse = await client.send(getCommand);

    if (!getResponse.Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "Item not found" }),
      };
    }

    const updateCommand = new UpdateItemCommand({
      TableName: TABLE_NAME,
      Key: {
        id: { S: "1" },
      },
      UpdateExpression: "SET #v = if_not_exists(#v, :start) + :inc",
      ExpressionAttributeNames: {
        "#v": "view",
      },
      ExpressionAttributeValues: {
        ":inc": { N: "1" },
        ":start": { N: "0" },
      },
      ReturnValues: "ALL_NEW",
    });

    const updateResponse = await client.send(updateCommand);

    const updatedItem = unmarshall(updateResponse.Attributes);

    return {
      statusCode: 200,
      body: JSON.stringify({ view: updatedItem.view }),
    };
  } catch (err) {
    console.error("Error fetching/updating item:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Internal Server Error" }),
    };
  }
};
