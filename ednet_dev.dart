/// In this example, the getTitle() method in the TextContent and AudioContent
/// classes now generates the title based on the Content properties,
/// by adding a prefix "TextContent
abstract class Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final ContentReading reading;
  final ContentLocalization localization;
  String pathId;

  String generatePathId();

  String getTitle();

  String getDescription();

  String getLanguage();
}

class TextContent extends Content {
  final TextContentFormat format;
  final TextContentPageCount pageCount;

  String generatePathId() {
    return "content.blog.articles.tech.flutter.text.TextContent.$title.$id";
  }

  String getTitle() => "TextContent: " + title;

  String getDescription() => description;

  String getLanguage() => language;
}

class AudioContent extends Content {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;

  String generatePathId() {
    return "content.podcasts.tech.flutter.audio.AudioContent.$title.$id";
  }

  String getTitle() => "AudioContent: " + title;

  String getDescription() => description;

  String getLanguage() => language;
}

class TextContent extends Content {
  final TextContentFormat format;
  final TextContentPageCount pageCount;

  String generatePathId() {
    return "content.blog.articles.tech.flutter.text.TextContent.$title.$id";
  }

  String getTitle() => title;

  String getDescription() => description;

  String getLanguage() => language;
}

class AudioContent extends Content {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;

  String generatePathId() {
    return "content.podcasts.tech.flutter.audio.AudioContent.$title.$id";
  }

  String getTitle() => title;

  String getDescription() => description;

  String getLanguage() => language;
}

abstract class Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final ContentReading reading;
  final ContentLocalization localization;
  String pathId;

  String generatePathId();

  String getTitle();

  String getDescription();

  String getLanguage();
}

class TextContent extends Content {
  final TextContentFormat format;
  final TextContentPageCount pageCount;

  String generatePathId() {
    return "developerAddedSemanticUseCase.Domain.subdomain.module.submodule.component.subcomponent.type.subtype.TextContent.$title.$id";
  }

  String getTitle() => title;

  String getDescription() => description;

  String getLanguage() => language;
}

class AudioContent extends Content {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;

  String generatePathId() {
    return "developerAddedSemanticUseCase.Domain.subdomain.module.submodule.component.subcomponent.type.subtype.AudioContent.$title.$id";
  }

  String getTitle() => title;

  String getDescription() => description;

  String getLanguage() => language;
}


abstract class Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final ContentReading reading;
  final ContentLocalization localization;

  String getTitle();

  String getDescription();

  String getLanguage();
}

class TextContent extends Content {
  final TextContentFormat format;
  final TextContentPageCount pageCount;

  String getTitle() => title;

  String getDescription() => description;

  String getLanguage() => language;
}

class LocalizedContent implements Content {
  final Content content;
  final ContentLocalization localization;

  LocalizedContent(this.content, this.localization);

  String getTitle() => localization.title ?? content.getTitle();

  String getDescription() =>
      localization.description ?? content.getDescription();

  String getLanguage() => localization.language ?? content.getLanguage();
}


class Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final ContentReading reading;
  final ContentLocalization localization;
}

class ContentReading {
  final ContentReadingFormat readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
}

class ContentLocalization {
  final Map<String, ContentLocalizationData> localizationData;
}

class ContentLocalizationData {
  final ContentTitle title;
  final ContentDescription description;
  final ContentLanguage language;
}

class TextContent extends Content {
  final TextContentFormat format;
  final TextContentPageCount pageCount;
}

class AudioContent extends Content {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;
}

abstract class Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final ContentReadingFormat readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
  final Map<String, ContentLocalization> localization;

  Content({
    this.id,
    this.title,
    this.description,
    this.contentType,
    this.keywords,
    this.author,
    this.language,
    this.ageGroup,
    this.readingFormat,
    this.readingSpeed,
    this.readingStyle,
    this.deviceCompatibility,
    this.popularity,
    this.socialImpact,
    this.targetAudience,
    this.contentTrend,
    this.topicRelevance,
    this.localization,
  });
}

class TextContent extends Content {
  final TextContentFormat format;
  final TextContentPageCount pageCount;

  TextContent

  (

  {

  ContentId

  id

  ,

  ContentTitle

  title

  ,

  ContentDescription

  description

  ,

  ContentType

  contentType

  ,

  List

  <

  ContentKeyword

  >

  keywords

  ,

  ContentAuthor

  author

  ,

  ContentLanguage

  language

  ,

  ContentAgeGroup

  ageGroup

  ,

  ContentReadingFormat

  reading

  ContentReadingSpeed

  readingSpeed

  ,

}}

abstract class Content<T> {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final T readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
  final Map<String, ContentLocalization> localization;
}

class TextContent extends Content<TextContentReadingFormat> {
  final TextContentFormat format;
  final TextContentPageCount pageCount;
}

class AudioContent extends Content<AudioContentReadingFormat> {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;
}

class ContentLocalization {
  final ContentTitle title;
  final ContentDescription description;
  final ContentLanguage language;
}

abstract class Content<T> {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final T readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
  final Map<String, ContentLocalization> localization;
}

class TextContent extends Content<TextContentReadingFormat> {
  final TextContentFormat format;
  final TextContentPageCount pageCount;
}

class AudioContent extends Content<AudioContentReadingFormat> {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;
}
class Content {
  final String title;
  final String description;
  final ContentType contentType;
  final ContentSense contentSense;
  final List<String> keywords;
  final String author;
  final String language;
  final String ageGroup; // e.g "kids","adults","elderly"
  final String readingLevel; // e.g "easy","intermediate","difficult"
  final String readingFormat; // e.g "text","audio","video"
  final String readingSpeed; // e.g "slow","normal","fast"
  final String readingStyle; // e.g "serious","humorous","informative"

  Content({
    required this.title,
    required this.description,
    required this.contentType,
    required this.contentSense,
    required this.keywords,
    required this.author,
    required this.language,
    required this.ageGroup,
    required this.readingLevel,
    required this.readingFormat,
    required this.readingSpeed,
    required this.readingStyle
  });
}

class ContentLocalization {
  final ContentTitle title;
  final ContentDescription description;
  final ContentLanguage language;
}


/// Abstract class representing the content.
///
/// Each attribute of content is implemented as specialized class that inherits from this base class.
///
/// [ContentId] is unique identifier for content.
/// [ContentTitle] represents title of the content.
/// [ContentDescription] represents description of the content.
/// [ContentType] represents type of the content.
/// [ContentKeyword] represents list of keywords associated with the content.
/// [ContentAuthor] represents the author of the content.
/// [ContentLanguage] represents the language of the content.
/// [ContentAgeGroup] represents the age group for which the content is suitable.
/// [T] represents the reading format of the content.
/// [ContentReadingSpeed] represents the reading speed of the content.
/// [ContentReadingStyle] represents the reading style of the content.
/// [ContentDeviceCompatibility] represents the device compatibility of the content.
/// [ContentPopularity] represents the popularity of the content.
/// [ContentSocialImpact] represents the social impact of the content.
/// [ContentTargetAudience] represents the target audience of the content.
/// [ContentTrend] represents the trend of the content.
/// [ContentTopicRelevance] represents the topic relevance of the content.
abstract class Content<T> {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final T readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
}

/// Specialized class representing the text content.
///
/// Inherits from [Content] and implements additional attributes specific to text content.
///
/// [TextContentFormat] represents the format of the text content.
/// [TextContentPageCount] represents the page count of the text content.
class TextContent extends Content<TextContentReadingFormat> {
  final TextContentFormat format;
  final TextContentPageCount pageCount;
}

/// Specialized class representing the audio content.
///
/// Inherits from [Content] and implements additional attributes specific to audio content.
///
/// [AudioContentDuration] represents the duration of the audio content.
/// [AudioContentBitrate] represents the bitrate of the audio content.
class AudioContent extends Content<AudioContentReadingFormat> {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;
}

abstract class Content<T> {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final T readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
}

class TextContent extends Content<TextContentReadingFormat> {
  final TextContentFormat format;
  final TextContentPageCount pageCount;
}

class AudioContent extends Content<AudioContentReadingFormat> {
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;
}

abstract class Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final ContentReadingFormat readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
}

class TextContent implements Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final TextContentReadingFormat readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
  final TextContentFormat format;
  final TextContentPageCount pageCount;
}

class AudioContent implements Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final AudioContentReadingFormat readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
  final AudioContentDuration duration;
  final AudioContentBitrate bitrate;
}

class Content {
  final ContentId id;
  final ContentTitle title;
  final ContentDescription description;
  final ContentType contentType;
  final List<ContentKeyword> keywords;
  final ContentAuthor author;
  final ContentLanguage language;
  final ContentAgeGroup ageGroup;
  final ContentReadingFormat readingFormat;
  final ContentReadingSpeed readingSpeed;
  final ContentReadingStyle readingStyle;
  final List<ContentDeviceCompatibility> deviceCompatibility;
  final ContentPopularity popularity;
  final ContentSocialImpact socialImpact;
  final ContentTargetAudience targetAudience;
  final ContentTrend contentTrend;
  final ContentTopicRelevance topicRelevance;
}

class ContentId {
  final String value;

  ContentId(this.value);
}

class ContentTitle {
  final String value;

  ContentTitle(this.value);
}

class ContentDescription {
  final String value;

  ContentDescription(this.value);
}

class ContentKeyword {
  final String value;

  ContentKeyword(this.value);
}

class ContentAuthor {
  final String value;

  ContentAuthor(this.value);
}

class ContentLanguage {
  final String value;

  ContentLanguage(this.value);
}

class ContentAgeGroup {
  final String value;

  ContentAgeGroup(this.value);
}

class ContentReadingFormat {
  final String value;

  ContentReadingFormat(this.value);
}

class ContentReadingSpeed {
  final String value;

  ContentReadingSpeed
}

class Content {
  final String title;
  final String description;
  final ContentType contentType;
  final ContentSense contentSense;
  final List<String> keywords;
  final String author;
  final String language;
  final AgeGroup ageGroup;
  final ReadingLevel readingLevel;
  final ReadingFormat readingFormat;
  final ReadingSpeed readingSpeed;
  final ReadingStyle readingStyle;
  final Map<DeviceType, bool> deviceCompatibility;
  final double popularity;
  final SocialImpact socialImpact;
  final TargetAudience targetAudience;
  final ContentTrend contentTrend;
  final TopicRelevance topicRelevance;

  Content({
    required this.title,
    required this.description,
    required this.contentType,
    required this.contentSense,
    required this.keywords,
    required this.author,
    required this.language,
    required this.ageGroup,
    required this.readingLevel,
    required this.readingFormat,
    required this.readingSpeed,
    required this.readingStyle,
    required this.deviceCompatibility,
    required this.popularity,
    required this.socialImpact,
    required this.targetAudience,
    required this.contentTrend,
    required this.topicRelevance
  });
}

enum SocialImpact {
  positive,
  negative,
  neutral
}

enum TargetAudience

  class Content {
  final String title;
  final String description;
  final ContentType contentType;
  final ContentSense contentSense;
  final List<String> keywords;
  final String author;
  final String language;
  final AgeGroup ageGroup;
  final ReadingLevel readingLevel;
  final ReadingFormat readingFormat;
  final ReadingSpeed readingSpeed;
  final ReadingStyle readingStyle;
  final Map<DeviceType,bool> deviceCompatibility;

  Content({
  required this.title,
  required this.description,
  required this.contentType,
  required this.contentSense,
  required this.keywords,
  required this.author,
  required this.language,
  required this.ageGroup,
  required this.readingLevel,
  required this.readingFormat,
  required this.readingSpeed,
  required this.readingStyle,
  required this.deviceCompatibility
  });
  }

  enum AgeGroup {
  kids,
  adults,
  elderly
  }

  enum ReadingLevel {
  easy,
  intermediate,
  difficult
  }

  enum ReadingFormat {
  text,
  audio,
  video
  }

  enum ReadingSpeed {
  slow,
  normal,
  fast
  }

  enum ReadingStyle {
  serious,
  humorous,
  informative
  }
}

bool isCompatibleWithDevice(Content content, DeviceType deviceType) {
  return content.deviceCompatibility[deviceType];
}

class Content {
  final String title;
  final String description;
  final ContentType contentType;
  final ContentSense contentSense;
  final List<String> keywords;
  final String author;
  final String language;
  final String ageGroup;
  final String readingLevel;
  final String readingFormat;
  final String readingSpeed;
  final String readingStyle;
  final Map<DeviceType,bool> deviceCompatibility;

  Content({
    required this.title,
    required this.description,
    required this.contentType,
    required this.contentSense,
    required this.keywords,
    required this.author,
    required this.language,
    required this.ageGroup,
    required this.readingLevel,
    required this.readingFormat,
    required this.readingSpeed,
    required this.readingStyle,
    required this.deviceCompatibility
  });
}

enum DeviceType {
  visual,
  auditory,
  olfactory,
  gustatory,
  tactile
}


