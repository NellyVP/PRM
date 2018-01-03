//
//  PRMModelFactoryTests.m
//  PremierObjCTests
//
//  Created by Nilofar Vahab poor on 03/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PRMModelFactory.h"
#import "PRMServiceHandler.h"


@interface PRMModelFactoryTests : XCTestCase

@end

@implementation PRMModelFactoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testThatModelFactoryCanBeInitializedAndDeinitialized {
    // Given
    PRMModelFactory *modelFactory = [[PRMModelFactory alloc] init];
    // Then
    XCTAssertNotNil(modelFactory, "modelFact should not be nil");
    // When
    modelFactory = nil;
    // Then
    XCTAssertNil(modelFactory, "modelFact should be nil");

}

- (void) testThatModelFactoryCanReturnMovieFromJSON {
    NSError* error = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"GetMovieSuccess" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];

    // Given
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    // Then
    XCTAssertNotNil(jsonDict, "jsonDict should not be nil");
    
    // When
    NSArray *arrayOfMovies = [PRMModelFactory moviesArrayFromDictionary:jsonDict];
    
    // Then
    XCTAssertNotNil(arrayOfMovies, "arrayOfMovies should not be nil");
}

@end
