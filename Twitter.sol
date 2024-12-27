// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

contract Twitter {
    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address author, uint256 id, uint256 newLikeCount);
    event TweetUnliked(address unliker, address author, uint256 id, uint256 newLikeCount);

    uint256 MAX_TWEET_LENGTH = 10;
    address owner;
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping (address => Tweet[]) public tweets;

    constructor(){
        owner = msg.sender;
    }

    modifier is_Tweet_Length(string memory _tweet) {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long!");
        _;
    }
    modifier onlyOwner() {
        require(owner == msg.sender, "Only the owner can perform this.");
        _;
    }

    function changeTweetLength(uint256 newLength) public onlyOwner {
        MAX_TWEET_LENGTH = newLength;
    }

    function createTweet(string calldata _tweet) public is_Tweet_Length(_tweet) {
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address _author, uint256 _id) external {
        // This does not work as it reverts the moment it does not find a value with
        // the provided author or id and does not show error message.
        // require(tweets[_author][_id].id==_id, "Tweet does not exist!");
        require(_id<tweets[_author].length, "Tweet does not exist!");
        tweets[_author][_id].likes++;

        emit TweetLiked(msg.sender, _author, _id, tweets[_author][_id].likes);
    }

    function unlikeTweet(address _author, uint256 _id) external {
        require(_id<tweets[_author].length, "Tweet does not exist!");
        require(tweets[_author][_id].likes>0, "Tweet has no likes!");
        tweets[_author][_id].likes--;

        emit TweetUnliked(msg.sender, _author, _id, tweets[_author][_id].likes);
    }

    function getTweet(uint256 tweetNo) public view returns(Tweet memory) {
        return tweets[msg.sender][tweetNo];
    }

    function getAllTweets() public view returns(Tweet[] memory) {
        return tweets[msg.sender];
    }
}