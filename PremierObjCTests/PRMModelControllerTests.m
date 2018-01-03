//
//  PRMModelControllerTests.m
//  PremierObjCTests
//
//  Created by Nilofar Vahab poor on 03/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PRMModelController.h"

@interface PRMModelControllerTests : XCTestCase <PRMModelControllerDelegate>{
    XCTestExpectation *serverRespondExpectation;
}

@end

@implementation PRMModelControllerTests

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

- (void) testThatModelControllerCanBeInitializedAndDeinitialized {
    // Given
    PRMModelController *controller = [[PRMModelController alloc] init];
    controller.delegate = self;
    
    // Then
    XCTAssertNotNil(controller, "controller should not be nil");

    // When
    controller = nil;
    // Then
    XCTAssertNil(controller, "controller should be nil");
}

- (void) testThatTheDelegateMethodIsCalledOnceTheRequestIsCompleted {
    // Given
    PRMModelController *controller = [[PRMModelController alloc] init];
    controller.delegate = self;
    
    // Then
    XCTAssertNotNil(controller, "controller should not be nil");
    
    // When
    serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error) {
            XCTAssert(NO, @"Fail");
        }
    }];
    
    // Then
    XCTAssert(YES, @"Pass");
}

- (void)controller:(PRMModelController *)controller searchEndedWithResults:(NSArray *)results {
    [serverRespondExpectation fulfill];
    XCTAssertNotNil(results,@"results returned from the url is not nil");
}

@end
