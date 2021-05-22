-- This file contains extra tests for the function "minimumWeight".  
-- These tests are not included in the package's standard tests because
-- they take too long to execute.

pathToPackage = "./CodingTheory.m2"
installPackage(
    "CodingTheory",
    FileName=>pathToPackage,
    RunExamples => true,
    RerunExamples => false
    )

error "stop"

testCorrectness = genMat -> (    
    -- It is important to make multiple instances of the same code for this
    -- test because otherwise the cached minimum distance will be returned. 
    
    C0 = linearCode genMat;
    C1 = linearCode genMat;
    C2 = linearCode genMat;
    
    A = minimumWeight(C1, Strategy=>"MatroidPartition");
    B = minimumWeight(C2, Strategy=>"OneInfoSet");
    C = minimumWeight(C0, Strategy=>"BruteForce");    

    print("MatroidPartition: "|toString(A));
    print("      OneInfoSet: "|toString(B));
    print("      BruteForce: "|toString(C));
    
    if A != B or A != C then(
	print("Generator matrix:");
    	print("matrix(F,"|toString(entries genMat)|")");      
	error "Found a bug.";
	);
    );
 
testPerformance = genMat -> (    
    -- It is important to make multiple instances of the same code for this
    -- test because otherwise the cached minimum distance will be returned. 
    C0 = linearCode genMat;
    C1 = linearCode genMat;
    
    print("Estimated strategy: "|(chooseStrat C0));
    print("MatroidPartition:");
    time A = minimumWeight(C0, Strategy=>"MatroidPartition");
    print("OneInfoSet:");
    time B = minimumWeight(C1, Strategy=>"OneInfoSet");
    
    if A != B then(
    	print("Minimum distance mismatch found.");
	print("Generator matrix:");
    	print("matrix(F,"|toString(entries genMat)|")");      
	error "Found a bug.";
	)
    
    );


-- Note: these parameters tend to produce linear codes that OneInfoSet handles the fastest. 
F = GF(4);
for i from 1 to 5 do(
    print("----------------------"|toString(i)|"----------------------");
    A := random(F^5,F^15);
    testCorrectness(A);  
    )

-- Note: these parameters tend to produce linear code that MatroidPartition handles the fastest.
F = GF(16);
for i from 1 to 100 do(
    print("----------------------"|toString(i)|"----------------------");
    A := random(F^5,F^10);
    testPerformance(A);  
    )
