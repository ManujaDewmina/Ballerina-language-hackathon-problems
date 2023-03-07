// Introduce your solution here.
type DiscussionDetails record {|
    string title;
    string kind;
    string affectedVersion;
    int priority;
|};

table<DiscussionDetails> discussionDetails = table [];
