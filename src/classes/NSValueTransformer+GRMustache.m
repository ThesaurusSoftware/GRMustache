// The MIT License
//
// Copyright (c) 2013 Gwendal Roué
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

#import "NSValueTransformer+GRMustache.h"
#import "GRMustacheTag.h"
#import "GRMustacheContext.h"

@implementation NSValueTransformer (GRMustache)

#pragma mark - <GRMustacheRendering>

/**
 * Support for {{# formatter }}...{{ value }}...{{ value }}...{{/ formatter }}
 */
- (NSString *)renderForMustacheTag:(GRMustacheTag *)tag context:(GRMustacheContext *)context HTMLSafe:(BOOL *)HTMLSafe error:(NSError **)error
{
    context = [context contextByAddingTagDelegate:self];
    return [tag renderContentWithContext:context HTMLSafe:HTMLSafe error:error];
}

#pragma mark - <GRMustacheTagDelegate>

/**
 * Support for {{# formatter }}...{{ value }}...{{ value }}...{{/ formatter }}
 */
- (id)mustacheTag:(GRMustacheTag *)tag willRenderObject:(id)object
{
    // Process {{ value }}
    if (tag.type == GRMustacheTagTypeVariable) {
        return [self transformedValue:object];
    }
    
    // Don't process {{# value }}, {{^ value }}, {{$ value }}
    return object;
}

@end