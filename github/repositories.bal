// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

isolated function getUserRepository(string username, string repositoryName, string accessToken, 
                                    http:Client graphQlClient) returns @tainted Repository|error {
    string stringQuery = getFormulatedStringQueryForGetRepository(username, repositoryName);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    json validatedResponse = check getValidatedResponse(response);

    if (validatedResponse is map<json>) {
        var gitData = validatedResponse[GIT_DATA];
        if (gitData is map<json>) {
            var viewer = gitData[GIT_REPOSITORY];
            if (viewer is map<json>) {
                Repository repository = check viewer.cloneWithType(Repository);
                return repository;
            }
        }
    }
    error err = error(GITHUB_ERROR_CODE+ " Error parsing git repository response", message = "Error parsing git repository response");
    return err;
}

isolated function getAuthenticatedUserRepositoryList(int perPageCount, string accessToken, http:Client graphQlClient, 
                                                     string? nextPageCursor=()) returns @tainted RepositoryList|error {
        string stringQuery = getFormulatedStringQueryForGetAuthenticatedUserRepositoryList(perPageCount, 
                                                                                           nextPageCursor);
        http:Request request = new;
        setHeader(request, accessToken);
        json convertedQuery = check stringToJson(stringQuery);
        //Set headers and payload to the request
        constructRequest(request, <@untainted> convertedQuery);

        http:Response response = check graphQlClient->post(EMPTY_STRING, request);

        //Check for empty payloads and errors
        json validatedResponse = check getValidatedResponse(response);

        if (validatedResponse is map<json>) {
            var gitData = validatedResponse[GIT_DATA];
            if (gitData is map<json>) {
                var viewer = gitData[GIT_VIEWER];
                if (viewer is map<json>) {
                    var repositories = viewer[GIT_REPOSITORIES];
                    if(repositories is map<json>){
                        RepositoryListPayload repositoryListResponse = check repositories.cloneWithType(RepositoryListPayload);
                        RepositoryList repositoryList = {
                            repositories: repositoryListResponse.nodes,
                            pageInfo: repositoryListResponse.pageInfo,
                            totalCount: repositoryListResponse.totalCount
                        };
                        return repositoryList;
                    }
                }
            }
        }
        error err = error(GITHUB_ERROR_CODE+ " Error parsing git repository list response", message = "Error parsing git repository list response");
        return err;
    }

isolated function getUserRepositoryList(string username, int perPageCount, string accessToken, 
                                        http:Client graphQlClient, string? nextPageCursor = ()) 
                                        returns @tainted RepositoryList|error {
    string stringQuery = getFormulatedStringQueryForGetUserRepositoryList(username, perPageCount, nextPageCursor);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    json validatedResponse = check getValidatedResponse(response);

    if (validatedResponse is map<json>) {
        var gitData = validatedResponse[GIT_DATA];
        if (gitData is map<json>) {
            var viewer = gitData[GIT_USER];
            if (viewer is map<json>) {
                var repositories = viewer[GIT_REPOSITORIES];
                if(repositories is map<json>){
                    RepositoryListPayload repositoryListResponse = check repositories.cloneWithType(RepositoryListPayload);
                    RepositoryList repositoryList = {
                        repositories: repositoryListResponse.nodes,
                        pageInfo: repositoryListResponse.pageInfo,
                        totalCount: repositoryListResponse.totalCount
                    };
                    return repositoryList;
                }
            }
        }
    }
    error err = error(GITHUB_ERROR_CODE+ "Error parsing git repository list response", message = "Error parsing git repository list response");
    return err;
}

isolated function getOrganizationRepositoryList(string organizationName, int perPageCount, string accessToken, 
                                                http:Client graphQlClient, string? nextPageCursor = ()) 
                                                returns @tainted RepositoryList|error {
    string stringQuery = getFormulatedStringQueryForGetOrganizationRepositoryList(organizationName, perPageCount, 
                                                                                  nextPageCursor);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    json validatedResponse = check getValidatedResponse(response);

    if (validatedResponse is map<json>) {
        var gitData = validatedResponse[GIT_DATA];
        if (gitData is map<json>) {
            var viewer = gitData[GIT_ORGANIZATION];
            if (viewer is map<json>) {
                var repositories = viewer[GIT_REPOSITORIES];
                if(repositories is map<json>){
                    RepositoryListPayload repositoryListResponse = check repositories.cloneWithType(RepositoryListPayload);
                    RepositoryList repositoryList = {
                        repositories: repositoryListResponse.nodes,
                        pageInfo: repositoryListResponse.pageInfo,
                        totalCount: repositoryListResponse.totalCount
                    };
                    return repositoryList;
                }
            }
        }
    }
    error err = error(GITHUB_ERROR_CODE+ " Error parsing git repository list response", message = "Error parsing git repository list response");
    return err;
}

isolated function getRepositoryCollobaratorList(string ownerName, string repositoryName, int perPageCount, 
                                                string accessToken, http:Client graphQlClient, 
                                                string? nextPageCursor = ()) 
                                                returns @tainted CollaboratorList|error {
    string stringQuery = getFormulatedStringQueryForGetRepositoryCollaboratorList(ownerName, repositoryName, 
                                                                                  perPageCount, nextPageCursor);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    json validatedResponse = check getValidatedResponse(response);

    if (validatedResponse is map<json>) {
        var gitData = validatedResponse[GIT_DATA];
        if (gitData is map<json>) {
            var viewer = gitData[GIT_REPOSITORY];
            if (viewer is map<json>) {
                var repositories = viewer[GIT_COLLABORATORS];
                if(repositories is map<json>){
                    CollaboratorListPayload collaboratorListResponse = check repositories.cloneWithType(CollaboratorListPayload);
                    CollaboratorList collaboratorList = {
                        collaborators: collaboratorListResponse.nodes,
                        pageInfo: collaboratorListResponse.pageInfo,
                        totalCount: collaboratorListResponse.totalCount
                    };
                    return collaboratorList;
                }
            }
        }
    }
    error err = error(GITHUB_ERROR_CODE+ " Error parsing git collaborator list response", message = "Error parsing git collaborator list response");
    return err;
}

isolated function getRepositoryBranchList(string ownerName, string repositoryName, int perPageCount, 
                                          string accessToken, http:Client graphQlClient, string? nextPageCursor = ()) 
                                          returns @tainted BranchList|error {
    string stringQuery = getFormulatedStringQueryForGetRepositoryBranchList(ownerName, repositoryName, perPageCount, 
                                                                            nextPageCursor);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    json validatedResponse = check getValidatedResponse(response);

    if (validatedResponse is map<json>) {
        var gitData = validatedResponse[GIT_DATA];
        if (gitData is map<json>) {
            var viewer = gitData[GIT_REPOSITORY];
            if (viewer is map<json>) {
                var repositories = viewer[GIT_REFS];
                if(repositories is map<json>){
                    BranchListPayload branchListResponse = check repositories.cloneWithType(BranchListPayload);
                    BranchList branchList = {
                        branches: branchListResponse.nodes,
                        pageInfo: branchListResponse.pageInfo,
                        totalCount: branchListResponse.totalCount
                    };
                    return branchList;
                }
            }
        }
    }
    error err = error(GITHUB_ERROR_CODE+" Error parsing git branch list response", message = "Error parsing git branch list response");
    return err;
}

isolated function updateRepository(@tainted UpdateRepositoryInput updateRepositoryInput, string repositoryOwnerName, 
                                   string repositoryName, string accessToken, http:Client graphQlClient) 
                                   returns @tainted error? {
    if(updateRepositoryInput?.repositoryId is ()) {
        updateRepositoryInput["repositoryId"] = check getRepositoryId(repositoryOwnerName, repositoryName, accessToken,
                                                                      graphQlClient);
    }
    string stringQuery = getFormulatedStringQueryForUpdateRepository(updateRepositoryInput);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    _ = check getValidatedResponse(response);

}

isolated function getRepositoryIssueListAssignedToUser(string repositoryOwnerName, string repositoryName, 
                                                       string assignee, int perPageCount, string accessToken,
                                                        http:Client graphQlClient, string? nextPageCursor = ()) 
                                                        returns @tainted IssueList|error {
    string stringQuery = getFormulatedStringQueryForGetIssueListAssignedToUser(repositoryOwnerName, repositoryName, 
                                                                               assignee, perPageCount, nextPageCursor);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    json validatedResponse = check getValidatedResponse(response);

    if (validatedResponse is map<json>) {
        var gitData = validatedResponse[GIT_DATA];
        if (gitData is map<json>) {
            var viewer = gitData[GIT_REPOSITORY];
            if (viewer is map<json>) {
                var issues = viewer[GIT_ISSUES];
                if(issues is map<json>){
                    IssueListPayload issueListResponse = check issues.cloneWithType(IssueListPayload);
                    IssueList issueList = {
                        issues: issueListResponse.nodes,
                        pageInfo: issueListResponse.pageInfo,
                        totalCount: issueListResponse.totalCount
                    };
                    return issueList;
                }
            }
        }
    }
    error err = error(GITHUB_ERROR_CODE+ "Error parsing git issue list response", message = "Error parsing git issue list response");
    return err;
}

isolated function getRepositoryIssueList(string repositoryOwnerName, string repositoryName, IssueState[] states, 
                                         int perPageCount, string accessToken, http:Client graphQlClient, 
                                         string? nextPageCursor = ()) returns @tainted IssueList|error {
    string stringQuery = getFormulatedStringQueryForGetIssueList(repositoryOwnerName, repositoryName, states, 
                                                                 perPageCount, nextPageCursor);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    json validatedResponse = check getValidatedResponse(response);

    if (validatedResponse is map<json>) {
        var gitData = validatedResponse[GIT_DATA];
        if (gitData is map<json>) {
            var viewer = gitData[GIT_REPOSITORY];
            if (viewer is map<json>) {
                var issues = viewer[GIT_ISSUES];
                if(issues is map<json>){
                    IssueListPayload issueListResponse = check issues.cloneWithType(IssueListPayload);
                    IssueList issueList = {
                        issues: issueListResponse.nodes,
                        pageInfo: issueListResponse.pageInfo,
                        totalCount: issueListResponse.totalCount
                    };
                    return issueList;
                }
            }
        }
    }
    error err = error(GITHUB_ERROR_CODE+ "Error parsing git repository issue list response", message = "Error parsing git repository issue list response");
    return err;
}

isolated function createRepository(@tainted CreateRepositoryInput createRepositoryInput, string accessToken, http:Client graphQlClient) 
                                   returns @tainted error? {

    if (createRepositoryInput?.template is ()){
        createRepositoryInput["template"] = false;
    }
    if (createRepositoryInput?.hasWikiEnabled is ()){
        createRepositoryInput["hasWikiEnabled"] = false;
    }
    if (createRepositoryInput?.hasIssuesEnabled is ()){
        createRepositoryInput["hasIssuesEnabled"] = true;
    }

    string stringQuery = getFormulatedStringQueryForCreateRepository(createRepositoryInput);
    http:Request request = new;
    setHeader(request, accessToken);
    json convertedQuery = check stringToJson(stringQuery);
    //Set headers and payload to the request
    constructRequest(request, <@untainted> convertedQuery);

    http:Response response = check graphQlClient->post(EMPTY_STRING, request);

    //Check for empty payloads and errors
    _ = check getValidatedResponse(response);
}
