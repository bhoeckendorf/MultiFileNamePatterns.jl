using MultiFilePatterns
using Base.Test

@test get("A000a0001", "A") == 0
@test get("A000a0001", "a") == 1
@test get("A123B456", "A") == 123
@test get("A123B456", "B") == 456
@test get("A123B456", "A1") == 23
@test get("A123B456", "3B45") == 6
@test get("A123-456", "A") == 123
@test get("A123-456", "-") == 456
@test get("A123 456", "A") == 123
@test get("A123 456", " ") == 456
@test get("A123 456", " 4") == 56
@test get("A123 456", "3 ") == 456

@test get("A123.456", "A") == 123
#@test get("A123.456", ".") == 456  # fails

@test get("A00B001C245D76", "A", "B", "C", "D") == [0, 1, 245, 76]

@test_throws Exception get("A123 456", "3")

@test get("A123A456", "A") == 123  # problematic


@test set("A0B002", "A", 1) == "A1B002"
@test set("A0B002", "A", 12) == "A12B002"
@test set("A0B002", "A", 03) == "A3B002"
@test set("A0B002", "B", 0) == "A0B000"
@test set("A0B002", "B", 12) == "A0B012"
@test set("A0B002", "B", 123) == "A0B123"
@test set("A0B002", "B", 1234) == "A0B1234"
@test set("A0B002", "B00", 1234) == "A0B001234"

@test_throws Exception get("A0B002", "B002", 6)
@test_throws Exception get("A0B002", "A0", 6)

@test set("A0B002", "A", 12, "B", 6) == "A12B006"

@test set("A0B002A0", "A", 12, "B", 6) == "A12B006A12"
