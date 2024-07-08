 
// test/project/gtd/project_gtd_review_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void testProjectGtdReviews( 
    ProjectDomain projectDomain, GtdModel gtdModel, Reviews reviews) { 
  DomainSession session; 
  group("Testing Project.Gtd.Review", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      gtdModel.init(); 
    }); 
    tearDown(() { 
      gtdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(gtdModel.isEmpty, isFalse); 
      expect(reviews.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      expect(reviews.isEmpty, isTrue); 
      expect(reviews.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = gtdModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = gtdModel.toJson(); 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      gtdModel.fromJson(json); 
      expect(gtdModel.isEmpty, isFalse); 
 
      gtdModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = gtdModel.fromEntryToJson("Review"); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayEntryJson("Review"); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = gtdModel.fromEntryToJson("Review"); 
      reviews.clear(); 
      expect(reviews.isEmpty, isTrue); 
      gtdModel.fromJsonToEntry(json); 
      expect(reviews.isEmpty, isFalse); 
 
      reviews.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add review required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add review unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found review by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var review = reviews.singleWhereOid(ednetOid); 
      expect(review, isNull); 
    }); 
 
    test("Find review by oid", () { 
      var randomReview = gtdModel.reviews.random(); 
      var review = reviews.singleWhereOid(randomReview.oid); 
      expect(review, isNotNull); 
      expect(review, equals(randomReview)); 
    }); 
 
    test("Find review by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find review by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find review by attribute", () { 
      var randomReview = gtdModel.reviews.random(); 
      var review = 
          reviews.firstWhereAttribute("assessments", randomReview.assessments); 
      expect(review, isNotNull); 
      expect(review.assessments, equals(randomReview.assessments)); 
    }); 
 
    test("Select reviews by attribute", () { 
      var randomReview = gtdModel.reviews.random(); 
      var selectedReviews = 
          reviews.selectWhereAttribute("assessments", randomReview.assessments); 
      expect(selectedReviews.isEmpty, isFalse); 
      selectedReviews.forEach((se) => 
          expect(se.assessments, equals(randomReview.assessments))); 
 
      //selectedReviews.display(title: "Select reviews by assessments"); 
    }); 
 
    test("Select reviews by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select reviews by attribute, then add", () { 
      var randomReview = gtdModel.reviews.random(); 
      var selectedReviews = 
          reviews.selectWhereAttribute("assessments", randomReview.assessments); 
      expect(selectedReviews.isEmpty, isFalse); 
      expect(selectedReviews.source?.isEmpty, isFalse); 
      var reviewsCount = reviews.length; 
 
      var review = Review(reviews.concept); 
      review.assessments = 'wife'; 
      var added = selectedReviews.add(review); 
      expect(added, isTrue); 
      expect(reviews.length, equals(++reviewsCount)); 
 
      //selectedReviews.display(title: 
      //  "Select reviews by attribute, then add"); 
      //reviews.display(title: "All reviews"); 
    }); 
 
    test("Select reviews by attribute, then remove", () { 
      var randomReview = gtdModel.reviews.random(); 
      var selectedReviews = 
          reviews.selectWhereAttribute("assessments", randomReview.assessments); 
      expect(selectedReviews.isEmpty, isFalse); 
      expect(selectedReviews.source?.isEmpty, isFalse); 
      var reviewsCount = reviews.length; 
 
      var removed = selectedReviews.remove(randomReview); 
      expect(removed, isTrue); 
      expect(reviews.length, equals(--reviewsCount)); 
 
      randomReview.display(prefix: "removed"); 
      //selectedReviews.display(title: 
      //  "Select reviews by attribute, then remove"); 
      //reviews.display(title: "All reviews"); 
    }); 
 
    test("Sort reviews", () { 
      // no id attribute 
      // add compareTo method in the specific Review class 
      /* 
      reviews.sort(); 
 
      //reviews.display(title: "Sort reviews"); 
      */ 
    }); 
 
    test("Order reviews", () { 
      // no id attribute 
      // add compareTo method in the specific Review class 
      /* 
      var orderedReviews = reviews.order(); 
      expect(orderedReviews.isEmpty, isFalse); 
      expect(orderedReviews.length, equals(reviews.length)); 
      expect(orderedReviews.source?.isEmpty, isFalse); 
      expect(orderedReviews.source?.length, equals(reviews.length)); 
      expect(orderedReviews, isNot(same(reviews))); 
 
      //orderedReviews.display(title: "Order reviews"); 
      */ 
    }); 
 
    test("Copy reviews", () { 
      var copiedReviews = reviews.copy(); 
      expect(copiedReviews.isEmpty, isFalse); 
      expect(copiedReviews.length, equals(reviews.length)); 
      expect(copiedReviews, isNot(same(reviews))); 
      copiedReviews.forEach((e) => 
        expect(e, equals(reviews.singleWhereOid(e.oid)))); 
 
      //copiedReviews.display(title: "Copy reviews"); 
    }); 
 
    test("True for every review", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random review", () { 
      var review1 = gtdModel.reviews.random(); 
      expect(review1, isNotNull); 
      var review2 = gtdModel.reviews.random(); 
      expect(review2, isNotNull); 
 
      //review1.display(prefix: "random1"); 
      //review2.display(prefix: "random2"); 
    }); 
 
    test("Update review id with try", () { 
      // no id attribute 
    }); 
 
    test("Update review id without try", () { 
      // no id attribute 
    }); 
 
    test("Update review id with success", () { 
      // no id attribute 
    }); 
 
    test("Update review non id attribute with failure", () { 
      var randomReview = gtdModel.reviews.random(); 
      var afterUpdateEntity = randomReview.copy(); 
      afterUpdateEntity.assessments = 'text'; 
      expect(afterUpdateEntity.assessments, equals('text')); 
      // reviews.update can only be used if oid, code or id is set. 
      expect(() => reviews.update(randomReview, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomReview = gtdModel.reviews.random(); 
      randomReview.display(prefix:"before copy: "); 
      var randomReviewCopy = randomReview.copy(); 
      randomReviewCopy.display(prefix:"after copy: "); 
      expect(randomReview, equals(randomReviewCopy)); 
      expect(randomReview.oid, equals(randomReviewCopy.oid)); 
      expect(randomReview.code, equals(randomReviewCopy.code)); 
      expect(randomReview.assessments, equals(randomReviewCopy.assessments)); 
 
    }); 
 
    test("review action undo and redo", () { 
      var reviewCount = reviews.length; 
      var review = Review(reviews.concept); 
        review.assessments = 'time'; 
      reviews.add(review); 
      expect(reviews.length, equals(++reviewCount)); 
      reviews.remove(review); 
      expect(reviews.length, equals(--reviewCount)); 
 
      var action = AddCommand(session, reviews, review); 
      action.doIt(); 
      expect(reviews.length, equals(++reviewCount)); 
 
      action.undo(); 
      expect(reviews.length, equals(--reviewCount)); 
 
      action.redo(); 
      expect(reviews.length, equals(++reviewCount)); 
    }); 
 
    test("review session undo and redo", () { 
      var reviewCount = reviews.length; 
      var review = Review(reviews.concept); 
        review.assessments = 'big'; 
      reviews.add(review); 
      expect(reviews.length, equals(++reviewCount)); 
      reviews.remove(review); 
      expect(reviews.length, equals(--reviewCount)); 
 
      var action = AddCommand(session, reviews, review); 
      action.doIt(); 
      expect(reviews.length, equals(++reviewCount)); 
 
      session.past.undo(); 
      expect(reviews.length, equals(--reviewCount)); 
 
      session.past.redo(); 
      expect(reviews.length, equals(++reviewCount)); 
    }); 
 
    test("Review update undo and redo", () { 
      var review = gtdModel.reviews.random(); 
      var action = SetAttributeCommand(session, review, "assessments", 'web'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(review.assessments, equals(action.before)); 
 
      session.past.redo(); 
      expect(review.assessments, equals(action.after)); 
    }); 
 
    test("Review action with multiple undos and redos", () { 
      var reviewCount = reviews.length; 
      var review1 = gtdModel.reviews.random(); 
 
      var action1 = RemoveCommand(session, reviews, review1); 
      action1.doIt(); 
      expect(reviews.length, equals(--reviewCount)); 
 
      var review2 = gtdModel.reviews.random(); 
 
      var action2 = RemoveCommand(session, reviews, review2); 
      action2.doIt(); 
      expect(reviews.length, equals(--reviewCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(reviews.length, equals(++reviewCount)); 
 
      session.past.undo(); 
      expect(reviews.length, equals(++reviewCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(reviews.length, equals(--reviewCount)); 
 
      session.past.redo(); 
      expect(reviews.length, equals(--reviewCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var reviewCount = reviews.length; 
      var review1 = gtdModel.reviews.random(); 
      var review2 = gtdModel.reviews.random(); 
      while (review1 == review2) { 
        review2 = gtdModel.reviews.random();  
      } 
      var action1 = RemoveCommand(session, reviews, review1); 
      var action2 = RemoveCommand(session, reviews, review2); 
 
      var transaction = new Transaction("two removes on reviews", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      reviewCount = reviewCount - 2; 
      expect(reviews.length, equals(reviewCount)); 
 
      reviews.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      reviewCount = reviewCount + 2; 
      expect(reviews.length, equals(reviewCount)); 
 
      reviews.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      reviewCount = reviewCount - 2; 
      expect(reviews.length, equals(reviewCount)); 
 
      reviews.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var reviewCount = reviews.length; 
      var review1 = gtdModel.reviews.random(); 
      var review2 = review1; 
      var action1 = RemoveCommand(session, reviews, review1); 
      var action2 = RemoveCommand(session, reviews, review2); 
 
      var transaction = Transaction( 
        "two removes on reviews, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(reviews.length, equals(reviewCount)); 
 
      //reviews.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to review actions", () { 
      var reviewCount = reviews.length; 
 
      var reaction = ReviewReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var review = Review(reviews.concept); 
        review.assessments = 'tax'; 
      reviews.add(review); 
      expect(reviews.length, equals(++reviewCount)); 
      reviews.remove(review); 
      expect(reviews.length, equals(--reviewCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, reviews, review); 
      addCommand.doIt(); 
      expect(reviews.length, equals(++reviewCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, review, "assessments", 'revolution'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ReviewReaction implements ICommandReaction { 
  bool reactedOnAdd    = false; 
  bool reactedOnUpdate = false; 
 
  void react(ICommand action) { 
    if (action is IEntitiesCommand) { 
      reactedOnAdd = true; 
    } else if (action is IEntityCommand) { 
      reactedOnUpdate = true; 
    } 
  } 
} 
 
void main() { 
  var repository = ProjectGtdRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  GtdModel gtdModel = projectDomain.getModelEntries("Gtd") as GtdModel;  
  assert(gtdModel != null); 
  var reviews = gtdModel.reviews; 
  testProjectGtdReviews(projectDomain, gtdModel, reviews); 
} 
 
