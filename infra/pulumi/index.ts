import * as pulumi from "@pulumi/pulumi";

export const environment = pulumi.getStack();
