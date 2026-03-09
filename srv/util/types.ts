export type SafeResponse<T> = {
    /**
     * Whether API call to LLM was successful
     */
    success: true,
    /**
     * The full response returned by AI Core
     */
    response?: any, //TODO find correct type in AI core library
    /**
     * The first response, or a message to the end user if the call failed.
     */
    parsedData: T
} | {
    success: false,
};