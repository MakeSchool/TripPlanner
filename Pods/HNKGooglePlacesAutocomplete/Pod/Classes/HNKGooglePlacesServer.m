//
//  HNKGooglePlacesServer.m
//  HNKGooglePlacesAutocomplete
//
// Copyright (c) 2015 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "HNKGooglePlacesServer.h"
#import "HNKServer.h"

static NSString *const kHNKGooglePlacesServerBaseURL = @"https://maps.googleapis.com/maps/api/place/";

@implementation HNKGooglePlacesServer

#pragma mark - Overrides

static HNKServer *server = nil;

+ (void)initialize
{
    if (self == [HNKGooglePlacesServer class]) {

        server = [[HNKServer alloc] initWithBaseURL:kHNKGooglePlacesServerBaseURL];
    }
}

#pragma mark - Requests

+ (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion
{
    [server GET:path
        parameters:parameters
        completion:^(id responseObject, NSError *error) {

            if (completion) {

                if (error) {

                    completion(nil, error);
                    return;
                }

                completion(responseObject, nil);
            }

        }];
}

@end
