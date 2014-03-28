//
//  Gist.h
//  ObjectiveGist
//
//  Copyright (c) 2012 Chris Ledet
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "GistFile.h"

@interface Gist : NSObject {

@private
    NSURL* apiURL;
    NSString* gistId;
    NSString* gistDescription;
    NSURL* htmlURL;
    NSURL* gitPullURL;
    NSURL* gitPushURL;
    NSDate* createdAt;
    NSDate* updateAt;
    NSArray* files;
    NSString* userLogin;
    NSUInteger numberOfComments;
    BOOL isPublic;
    BOOL isFork;
}

@property (nonatomic, strong) NSURL* apiURL;
@property (nonatomic, strong) NSString* gistId;
@property (nonatomic, strong) NSString* gistDescription;
@property (nonatomic, strong) NSURL* htmlURL;
@property (nonatomic, strong) NSURL* gitPullURL;
@property (nonatomic, strong) NSURL* gitPushURL;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic, strong) NSArray* files;
@property (nonatomic, strong) NSString* userLogin;
@property (nonatomic, assign) NSUInteger numberOfComments;
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, assign) BOOL isFork;

- (id)initWithId:(NSString*)gistId;
- (id)initWithFiles:(NSArray*)files;

- (void)publish:(NSString*)accessToken;
- (void)destroy:(NSString*)accessToken;

@end
