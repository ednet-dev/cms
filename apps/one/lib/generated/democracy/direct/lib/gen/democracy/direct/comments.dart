part of democracy_direct;

// lib/gen/democracy/direct/comments.dart

abstract class CommentGen extends Entity<Comment> {

  CommentGen(Concept concept) {
    this.concept = concept;
        Concept commentConcept = concept.model.concepts.singleWhereCode("Comment") as Concept;
    assert(commentConcept != null);
    setChild("reply", Comments(commentConcept));

  }

  

    Reference get commenterReference => getReference("commenter") as Reference;
  void set commenterReference(Reference reference) => setReference("commenter", reference);

  Citizen get commenter => getParent("commenter") as Citizen;
  void set commenter(Citizen p) => setParent("commenter", p);

  Reference get replyToReference => getReference("replyTo") as Reference;
  void set replyToReference(Reference reference) => setReference("replyTo", reference);

  Comment get replyTo => getParent("replyTo") as Comment;
  void set replyTo(Comment p) => setParent("replyTo", p);

  Reference get replyToProposalReference => getReference("replyTo") as Reference;
  void set replyToProposalReference(Reference reference) => setReference("replyTo", reference);

  Proposal get replyToProposal => getParent("replyTo") as Proposal;
  void set replyToProposal(Proposal p) => setParent("replyTo", p);


    String get text => getAttribute("text");
  void set text(String a) => setAttribute("text", a);


    Comments get reply => getChild("reply") as Comments;


  @override
  Comment newEntity() => Comment(concept);

  Comments newEntities() => Comments(concept);

  
}

abstract class CommentsGen extends Entities<Comment> {

  CommentsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Comments newEntities() => Comments(concept);

  @override
  Comment newEntity() => Comment(concept);
}

// Commands for Comment will be generated here
// Events for Comment will be generated here
// Policies for Comment will be generated here
