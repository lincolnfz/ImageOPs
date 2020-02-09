// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/queue_runner.proto

#ifndef PROTOBUF_INCLUDED_tensorflow_2fcore_2fprotobuf_2fqueue_5frunner_2eproto
#define PROTOBUF_INCLUDED_tensorflow_2fcore_2fprotobuf_2fqueue_5frunner_2eproto

#include <limits>
#include <string>

#include <google/protobuf/port_def.inc>
#if PROTOBUF_VERSION < 3007000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers. Please update
#error your headers.
#endif
#if 3007001 < PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers. Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/port_undef.inc>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/arena.h>
#include <google/protobuf/arenastring.h>
#include <google/protobuf/generated_message_table_driven.h>
#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/inlined_string_field.h>
#include <google/protobuf/metadata.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>  // IWYU pragma: export
#include <google/protobuf/extension_set.h>  // IWYU pragma: export
#include <google/protobuf/unknown_field_set.h>
#include "tensorflow/core/lib/core/error_codes.pb.h"
// @@protoc_insertion_point(includes)
#include <google/protobuf/port_def.inc>
#define PROTOBUF_INTERNAL_EXPORT_tensorflow_2fcore_2fprotobuf_2fqueue_5frunner_2eproto

// Internal implementation detail -- do not use these members.
struct TableStruct_tensorflow_2fcore_2fprotobuf_2fqueue_5frunner_2eproto {
  static const ::google::protobuf::internal::ParseTableField entries[]
    PROTOBUF_SECTION_VARIABLE(protodesc_cold);
  static const ::google::protobuf::internal::AuxillaryParseTableField aux[]
    PROTOBUF_SECTION_VARIABLE(protodesc_cold);
  static const ::google::protobuf::internal::ParseTable schema[1]
    PROTOBUF_SECTION_VARIABLE(protodesc_cold);
  static const ::google::protobuf::internal::FieldMetadata field_metadata[];
  static const ::google::protobuf::internal::SerializationTable serialization_table[];
  static const ::google::protobuf::uint32 offsets[];
};
void AddDescriptors_tensorflow_2fcore_2fprotobuf_2fqueue_5frunner_2eproto();
namespace tensorflow {
class QueueRunnerDef;
class QueueRunnerDefDefaultTypeInternal;
extern QueueRunnerDefDefaultTypeInternal _QueueRunnerDef_default_instance_;
}  // namespace tensorflow
namespace google {
namespace protobuf {
template<> ::tensorflow::QueueRunnerDef* Arena::CreateMaybeMessage<::tensorflow::QueueRunnerDef>(Arena*);
}  // namespace protobuf
}  // namespace google
namespace tensorflow {

// ===================================================================

class QueueRunnerDef :
    public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:tensorflow.QueueRunnerDef) */ {
 public:
  QueueRunnerDef();
  virtual ~QueueRunnerDef();

  QueueRunnerDef(const QueueRunnerDef& from);

  inline QueueRunnerDef& operator=(const QueueRunnerDef& from) {
    CopyFrom(from);
    return *this;
  }
  #if LANG_CXX11
  QueueRunnerDef(QueueRunnerDef&& from) noexcept
    : QueueRunnerDef() {
    *this = ::std::move(from);
  }

  inline QueueRunnerDef& operator=(QueueRunnerDef&& from) noexcept {
    if (GetArenaNoVirtual() == from.GetArenaNoVirtual()) {
      if (this != &from) InternalSwap(&from);
    } else {
      CopyFrom(from);
    }
    return *this;
  }
  #endif
  inline ::google::protobuf::Arena* GetArena() const final {
    return GetArenaNoVirtual();
  }
  inline void* GetMaybeArenaPointer() const final {
    return MaybeArenaPtr();
  }
  static const ::google::protobuf::Descriptor* descriptor() {
    return default_instance().GetDescriptor();
  }
  static const QueueRunnerDef& default_instance();

  static void InitAsDefaultInstance();  // FOR INTERNAL USE ONLY
  static inline const QueueRunnerDef* internal_default_instance() {
    return reinterpret_cast<const QueueRunnerDef*>(
               &_QueueRunnerDef_default_instance_);
  }
  static constexpr int kIndexInFileMessages =
    0;

  void UnsafeArenaSwap(QueueRunnerDef* other);
  void Swap(QueueRunnerDef* other);
  friend void swap(QueueRunnerDef& a, QueueRunnerDef& b) {
    a.Swap(&b);
  }

  // implements Message ----------------------------------------------

  inline QueueRunnerDef* New() const final {
    return CreateMaybeMessage<QueueRunnerDef>(nullptr);
  }

  QueueRunnerDef* New(::google::protobuf::Arena* arena) const final {
    return CreateMaybeMessage<QueueRunnerDef>(arena);
  }
  void CopyFrom(const ::google::protobuf::Message& from) final;
  void MergeFrom(const ::google::protobuf::Message& from) final;
  void CopyFrom(const QueueRunnerDef& from);
  void MergeFrom(const QueueRunnerDef& from);
  PROTOBUF_ATTRIBUTE_REINITIALIZES void Clear() final;
  bool IsInitialized() const final;

  size_t ByteSizeLong() const final;
  #if GOOGLE_PROTOBUF_ENABLE_EXPERIMENTAL_PARSER
  static const char* _InternalParse(const char* begin, const char* end, void* object, ::google::protobuf::internal::ParseContext* ctx);
  ::google::protobuf::internal::ParseFunc _ParseFunc() const final { return _InternalParse; }
  #else
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input) final;
  #endif  // GOOGLE_PROTOBUF_ENABLE_EXPERIMENTAL_PARSER
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const final;
  ::google::protobuf::uint8* InternalSerializeWithCachedSizesToArray(
      ::google::protobuf::uint8* target) const final;
  int GetCachedSize() const final { return _cached_size_.Get(); }

  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const final;
  void InternalSwap(QueueRunnerDef* other);
  protected:
  explicit QueueRunnerDef(::google::protobuf::Arena* arena);
  private:
  static void ArenaDtor(void* object);
  inline void RegisterArenaDtor(::google::protobuf::Arena* arena);
  private:
  inline ::google::protobuf::Arena* GetArenaNoVirtual() const {
    return _internal_metadata_.arena();
  }
  inline void* MaybeArenaPtr() const {
    return _internal_metadata_.raw_arena_ptr();
  }
  public:

  ::google::protobuf::Metadata GetMetadata() const final;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // repeated string enqueue_op_name = 2;
  int enqueue_op_name_size() const;
  void clear_enqueue_op_name();
  static const int kEnqueueOpNameFieldNumber = 2;
  const ::std::string& enqueue_op_name(int index) const;
  ::std::string* mutable_enqueue_op_name(int index);
  void set_enqueue_op_name(int index, const ::std::string& value);
  #if LANG_CXX11
  void set_enqueue_op_name(int index, ::std::string&& value);
  #endif
  void set_enqueue_op_name(int index, const char* value);
  void set_enqueue_op_name(int index, const char* value, size_t size);
  ::std::string* add_enqueue_op_name();
  void add_enqueue_op_name(const ::std::string& value);
  #if LANG_CXX11
  void add_enqueue_op_name(::std::string&& value);
  #endif
  void add_enqueue_op_name(const char* value);
  void add_enqueue_op_name(const char* value, size_t size);
  const ::google::protobuf::RepeatedPtrField<::std::string>& enqueue_op_name() const;
  ::google::protobuf::RepeatedPtrField<::std::string>* mutable_enqueue_op_name();

  // repeated .tensorflow.error.Code queue_closed_exception_types = 5;
  int queue_closed_exception_types_size() const;
  void clear_queue_closed_exception_types();
  static const int kQueueClosedExceptionTypesFieldNumber = 5;
  ::tensorflow::error::Code queue_closed_exception_types(int index) const;
  void set_queue_closed_exception_types(int index, ::tensorflow::error::Code value);
  void add_queue_closed_exception_types(::tensorflow::error::Code value);
  const ::google::protobuf::RepeatedField<int>& queue_closed_exception_types() const;
  ::google::protobuf::RepeatedField<int>* mutable_queue_closed_exception_types();

  // string queue_name = 1;
  void clear_queue_name();
  static const int kQueueNameFieldNumber = 1;
  const ::std::string& queue_name() const;
  void set_queue_name(const ::std::string& value);
  #if LANG_CXX11
  void set_queue_name(::std::string&& value);
  #endif
  void set_queue_name(const char* value);
  void set_queue_name(const char* value, size_t size);
  ::std::string* mutable_queue_name();
  ::std::string* release_queue_name();
  void set_allocated_queue_name(::std::string* queue_name);
  GOOGLE_PROTOBUF_RUNTIME_DEPRECATED("The unsafe_arena_ accessors for"
  "    string fields are deprecated and will be removed in a"
  "    future release.")
  ::std::string* unsafe_arena_release_queue_name();
  GOOGLE_PROTOBUF_RUNTIME_DEPRECATED("The unsafe_arena_ accessors for"
  "    string fields are deprecated and will be removed in a"
  "    future release.")
  void unsafe_arena_set_allocated_queue_name(
      ::std::string* queue_name);

  // string close_op_name = 3;
  void clear_close_op_name();
  static const int kCloseOpNameFieldNumber = 3;
  const ::std::string& close_op_name() const;
  void set_close_op_name(const ::std::string& value);
  #if LANG_CXX11
  void set_close_op_name(::std::string&& value);
  #endif
  void set_close_op_name(const char* value);
  void set_close_op_name(const char* value, size_t size);
  ::std::string* mutable_close_op_name();
  ::std::string* release_close_op_name();
  void set_allocated_close_op_name(::std::string* close_op_name);
  GOOGLE_PROTOBUF_RUNTIME_DEPRECATED("The unsafe_arena_ accessors for"
  "    string fields are deprecated and will be removed in a"
  "    future release.")
  ::std::string* unsafe_arena_release_close_op_name();
  GOOGLE_PROTOBUF_RUNTIME_DEPRECATED("The unsafe_arena_ accessors for"
  "    string fields are deprecated and will be removed in a"
  "    future release.")
  void unsafe_arena_set_allocated_close_op_name(
      ::std::string* close_op_name);

  // string cancel_op_name = 4;
  void clear_cancel_op_name();
  static const int kCancelOpNameFieldNumber = 4;
  const ::std::string& cancel_op_name() const;
  void set_cancel_op_name(const ::std::string& value);
  #if LANG_CXX11
  void set_cancel_op_name(::std::string&& value);
  #endif
  void set_cancel_op_name(const char* value);
  void set_cancel_op_name(const char* value, size_t size);
  ::std::string* mutable_cancel_op_name();
  ::std::string* release_cancel_op_name();
  void set_allocated_cancel_op_name(::std::string* cancel_op_name);
  GOOGLE_PROTOBUF_RUNTIME_DEPRECATED("The unsafe_arena_ accessors for"
  "    string fields are deprecated and will be removed in a"
  "    future release.")
  ::std::string* unsafe_arena_release_cancel_op_name();
  GOOGLE_PROTOBUF_RUNTIME_DEPRECATED("The unsafe_arena_ accessors for"
  "    string fields are deprecated and will be removed in a"
  "    future release.")
  void unsafe_arena_set_allocated_cancel_op_name(
      ::std::string* cancel_op_name);

  // @@protoc_insertion_point(class_scope:tensorflow.QueueRunnerDef)
 private:
  class HasBitSetters;

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  template <typename T> friend class ::google::protobuf::Arena::InternalHelper;
  typedef void InternalArenaConstructable_;
  typedef void DestructorSkippable_;
  ::google::protobuf::RepeatedPtrField<::std::string> enqueue_op_name_;
  ::google::protobuf::RepeatedField<int> queue_closed_exception_types_;
  mutable std::atomic<int> _queue_closed_exception_types_cached_byte_size_;
  ::google::protobuf::internal::ArenaStringPtr queue_name_;
  ::google::protobuf::internal::ArenaStringPtr close_op_name_;
  ::google::protobuf::internal::ArenaStringPtr cancel_op_name_;
  mutable ::google::protobuf::internal::CachedSize _cached_size_;
  friend struct ::TableStruct_tensorflow_2fcore_2fprotobuf_2fqueue_5frunner_2eproto;
};
// ===================================================================


// ===================================================================

#ifdef __GNUC__
  #pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wstrict-aliasing"
#endif  // __GNUC__
// QueueRunnerDef

// string queue_name = 1;
inline void QueueRunnerDef::clear_queue_name() {
  queue_name_.ClearToEmpty(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline const ::std::string& QueueRunnerDef::queue_name() const {
  // @@protoc_insertion_point(field_get:tensorflow.QueueRunnerDef.queue_name)
  return queue_name_.Get();
}
inline void QueueRunnerDef::set_queue_name(const ::std::string& value) {
  
  queue_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value, GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set:tensorflow.QueueRunnerDef.queue_name)
}
#if LANG_CXX11
inline void QueueRunnerDef::set_queue_name(::std::string&& value) {
  
  queue_name_.Set(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value), GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_rvalue:tensorflow.QueueRunnerDef.queue_name)
}
#endif
inline void QueueRunnerDef::set_queue_name(const char* value) {
  GOOGLE_DCHECK(value != nullptr);
  
  queue_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value),
              GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_char:tensorflow.QueueRunnerDef.queue_name)
}
inline void QueueRunnerDef::set_queue_name(const char* value,
    size_t size) {
  
  queue_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(
      reinterpret_cast<const char*>(value), size), GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_pointer:tensorflow.QueueRunnerDef.queue_name)
}
inline ::std::string* QueueRunnerDef::mutable_queue_name() {
  
  // @@protoc_insertion_point(field_mutable:tensorflow.QueueRunnerDef.queue_name)
  return queue_name_.Mutable(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline ::std::string* QueueRunnerDef::release_queue_name() {
  // @@protoc_insertion_point(field_release:tensorflow.QueueRunnerDef.queue_name)
  
  return queue_name_.Release(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline void QueueRunnerDef::set_allocated_queue_name(::std::string* queue_name) {
  if (queue_name != nullptr) {
    
  } else {
    
  }
  queue_name_.SetAllocated(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), queue_name,
      GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_allocated:tensorflow.QueueRunnerDef.queue_name)
}
inline ::std::string* QueueRunnerDef::unsafe_arena_release_queue_name() {
  // @@protoc_insertion_point(field_unsafe_arena_release:tensorflow.QueueRunnerDef.queue_name)
  GOOGLE_DCHECK(GetArenaNoVirtual() != nullptr);
  
  return queue_name_.UnsafeArenaRelease(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      GetArenaNoVirtual());
}
inline void QueueRunnerDef::unsafe_arena_set_allocated_queue_name(
    ::std::string* queue_name) {
  GOOGLE_DCHECK(GetArenaNoVirtual() != nullptr);
  if (queue_name != nullptr) {
    
  } else {
    
  }
  queue_name_.UnsafeArenaSetAllocated(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      queue_name, GetArenaNoVirtual());
  // @@protoc_insertion_point(field_unsafe_arena_set_allocated:tensorflow.QueueRunnerDef.queue_name)
}

// repeated string enqueue_op_name = 2;
inline int QueueRunnerDef::enqueue_op_name_size() const {
  return enqueue_op_name_.size();
}
inline void QueueRunnerDef::clear_enqueue_op_name() {
  enqueue_op_name_.Clear();
}
inline const ::std::string& QueueRunnerDef::enqueue_op_name(int index) const {
  // @@protoc_insertion_point(field_get:tensorflow.QueueRunnerDef.enqueue_op_name)
  return enqueue_op_name_.Get(index);
}
inline ::std::string* QueueRunnerDef::mutable_enqueue_op_name(int index) {
  // @@protoc_insertion_point(field_mutable:tensorflow.QueueRunnerDef.enqueue_op_name)
  return enqueue_op_name_.Mutable(index);
}
inline void QueueRunnerDef::set_enqueue_op_name(int index, const ::std::string& value) {
  // @@protoc_insertion_point(field_set:tensorflow.QueueRunnerDef.enqueue_op_name)
  enqueue_op_name_.Mutable(index)->assign(value);
}
#if LANG_CXX11
inline void QueueRunnerDef::set_enqueue_op_name(int index, ::std::string&& value) {
  // @@protoc_insertion_point(field_set:tensorflow.QueueRunnerDef.enqueue_op_name)
  enqueue_op_name_.Mutable(index)->assign(std::move(value));
}
#endif
inline void QueueRunnerDef::set_enqueue_op_name(int index, const char* value) {
  GOOGLE_DCHECK(value != nullptr);
  enqueue_op_name_.Mutable(index)->assign(value);
  // @@protoc_insertion_point(field_set_char:tensorflow.QueueRunnerDef.enqueue_op_name)
}
inline void QueueRunnerDef::set_enqueue_op_name(int index, const char* value, size_t size) {
  enqueue_op_name_.Mutable(index)->assign(
    reinterpret_cast<const char*>(value), size);
  // @@protoc_insertion_point(field_set_pointer:tensorflow.QueueRunnerDef.enqueue_op_name)
}
inline ::std::string* QueueRunnerDef::add_enqueue_op_name() {
  // @@protoc_insertion_point(field_add_mutable:tensorflow.QueueRunnerDef.enqueue_op_name)
  return enqueue_op_name_.Add();
}
inline void QueueRunnerDef::add_enqueue_op_name(const ::std::string& value) {
  enqueue_op_name_.Add()->assign(value);
  // @@protoc_insertion_point(field_add:tensorflow.QueueRunnerDef.enqueue_op_name)
}
#if LANG_CXX11
inline void QueueRunnerDef::add_enqueue_op_name(::std::string&& value) {
  enqueue_op_name_.Add(std::move(value));
  // @@protoc_insertion_point(field_add:tensorflow.QueueRunnerDef.enqueue_op_name)
}
#endif
inline void QueueRunnerDef::add_enqueue_op_name(const char* value) {
  GOOGLE_DCHECK(value != nullptr);
  enqueue_op_name_.Add()->assign(value);
  // @@protoc_insertion_point(field_add_char:tensorflow.QueueRunnerDef.enqueue_op_name)
}
inline void QueueRunnerDef::add_enqueue_op_name(const char* value, size_t size) {
  enqueue_op_name_.Add()->assign(reinterpret_cast<const char*>(value), size);
  // @@protoc_insertion_point(field_add_pointer:tensorflow.QueueRunnerDef.enqueue_op_name)
}
inline const ::google::protobuf::RepeatedPtrField<::std::string>&
QueueRunnerDef::enqueue_op_name() const {
  // @@protoc_insertion_point(field_list:tensorflow.QueueRunnerDef.enqueue_op_name)
  return enqueue_op_name_;
}
inline ::google::protobuf::RepeatedPtrField<::std::string>*
QueueRunnerDef::mutable_enqueue_op_name() {
  // @@protoc_insertion_point(field_mutable_list:tensorflow.QueueRunnerDef.enqueue_op_name)
  return &enqueue_op_name_;
}

// string close_op_name = 3;
inline void QueueRunnerDef::clear_close_op_name() {
  close_op_name_.ClearToEmpty(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline const ::std::string& QueueRunnerDef::close_op_name() const {
  // @@protoc_insertion_point(field_get:tensorflow.QueueRunnerDef.close_op_name)
  return close_op_name_.Get();
}
inline void QueueRunnerDef::set_close_op_name(const ::std::string& value) {
  
  close_op_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value, GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set:tensorflow.QueueRunnerDef.close_op_name)
}
#if LANG_CXX11
inline void QueueRunnerDef::set_close_op_name(::std::string&& value) {
  
  close_op_name_.Set(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value), GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_rvalue:tensorflow.QueueRunnerDef.close_op_name)
}
#endif
inline void QueueRunnerDef::set_close_op_name(const char* value) {
  GOOGLE_DCHECK(value != nullptr);
  
  close_op_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value),
              GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_char:tensorflow.QueueRunnerDef.close_op_name)
}
inline void QueueRunnerDef::set_close_op_name(const char* value,
    size_t size) {
  
  close_op_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(
      reinterpret_cast<const char*>(value), size), GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_pointer:tensorflow.QueueRunnerDef.close_op_name)
}
inline ::std::string* QueueRunnerDef::mutable_close_op_name() {
  
  // @@protoc_insertion_point(field_mutable:tensorflow.QueueRunnerDef.close_op_name)
  return close_op_name_.Mutable(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline ::std::string* QueueRunnerDef::release_close_op_name() {
  // @@protoc_insertion_point(field_release:tensorflow.QueueRunnerDef.close_op_name)
  
  return close_op_name_.Release(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline void QueueRunnerDef::set_allocated_close_op_name(::std::string* close_op_name) {
  if (close_op_name != nullptr) {
    
  } else {
    
  }
  close_op_name_.SetAllocated(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), close_op_name,
      GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_allocated:tensorflow.QueueRunnerDef.close_op_name)
}
inline ::std::string* QueueRunnerDef::unsafe_arena_release_close_op_name() {
  // @@protoc_insertion_point(field_unsafe_arena_release:tensorflow.QueueRunnerDef.close_op_name)
  GOOGLE_DCHECK(GetArenaNoVirtual() != nullptr);
  
  return close_op_name_.UnsafeArenaRelease(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      GetArenaNoVirtual());
}
inline void QueueRunnerDef::unsafe_arena_set_allocated_close_op_name(
    ::std::string* close_op_name) {
  GOOGLE_DCHECK(GetArenaNoVirtual() != nullptr);
  if (close_op_name != nullptr) {
    
  } else {
    
  }
  close_op_name_.UnsafeArenaSetAllocated(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      close_op_name, GetArenaNoVirtual());
  // @@protoc_insertion_point(field_unsafe_arena_set_allocated:tensorflow.QueueRunnerDef.close_op_name)
}

// string cancel_op_name = 4;
inline void QueueRunnerDef::clear_cancel_op_name() {
  cancel_op_name_.ClearToEmpty(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline const ::std::string& QueueRunnerDef::cancel_op_name() const {
  // @@protoc_insertion_point(field_get:tensorflow.QueueRunnerDef.cancel_op_name)
  return cancel_op_name_.Get();
}
inline void QueueRunnerDef::set_cancel_op_name(const ::std::string& value) {
  
  cancel_op_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value, GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set:tensorflow.QueueRunnerDef.cancel_op_name)
}
#if LANG_CXX11
inline void QueueRunnerDef::set_cancel_op_name(::std::string&& value) {
  
  cancel_op_name_.Set(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value), GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_rvalue:tensorflow.QueueRunnerDef.cancel_op_name)
}
#endif
inline void QueueRunnerDef::set_cancel_op_name(const char* value) {
  GOOGLE_DCHECK(value != nullptr);
  
  cancel_op_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value),
              GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_char:tensorflow.QueueRunnerDef.cancel_op_name)
}
inline void QueueRunnerDef::set_cancel_op_name(const char* value,
    size_t size) {
  
  cancel_op_name_.Set(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(
      reinterpret_cast<const char*>(value), size), GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_pointer:tensorflow.QueueRunnerDef.cancel_op_name)
}
inline ::std::string* QueueRunnerDef::mutable_cancel_op_name() {
  
  // @@protoc_insertion_point(field_mutable:tensorflow.QueueRunnerDef.cancel_op_name)
  return cancel_op_name_.Mutable(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline ::std::string* QueueRunnerDef::release_cancel_op_name() {
  // @@protoc_insertion_point(field_release:tensorflow.QueueRunnerDef.cancel_op_name)
  
  return cancel_op_name_.Release(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), GetArenaNoVirtual());
}
inline void QueueRunnerDef::set_allocated_cancel_op_name(::std::string* cancel_op_name) {
  if (cancel_op_name != nullptr) {
    
  } else {
    
  }
  cancel_op_name_.SetAllocated(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), cancel_op_name,
      GetArenaNoVirtual());
  // @@protoc_insertion_point(field_set_allocated:tensorflow.QueueRunnerDef.cancel_op_name)
}
inline ::std::string* QueueRunnerDef::unsafe_arena_release_cancel_op_name() {
  // @@protoc_insertion_point(field_unsafe_arena_release:tensorflow.QueueRunnerDef.cancel_op_name)
  GOOGLE_DCHECK(GetArenaNoVirtual() != nullptr);
  
  return cancel_op_name_.UnsafeArenaRelease(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      GetArenaNoVirtual());
}
inline void QueueRunnerDef::unsafe_arena_set_allocated_cancel_op_name(
    ::std::string* cancel_op_name) {
  GOOGLE_DCHECK(GetArenaNoVirtual() != nullptr);
  if (cancel_op_name != nullptr) {
    
  } else {
    
  }
  cancel_op_name_.UnsafeArenaSetAllocated(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      cancel_op_name, GetArenaNoVirtual());
  // @@protoc_insertion_point(field_unsafe_arena_set_allocated:tensorflow.QueueRunnerDef.cancel_op_name)
}

// repeated .tensorflow.error.Code queue_closed_exception_types = 5;
inline int QueueRunnerDef::queue_closed_exception_types_size() const {
  return queue_closed_exception_types_.size();
}
inline void QueueRunnerDef::clear_queue_closed_exception_types() {
  queue_closed_exception_types_.Clear();
}
inline ::tensorflow::error::Code QueueRunnerDef::queue_closed_exception_types(int index) const {
  // @@protoc_insertion_point(field_get:tensorflow.QueueRunnerDef.queue_closed_exception_types)
  return static_cast< ::tensorflow::error::Code >(queue_closed_exception_types_.Get(index));
}
inline void QueueRunnerDef::set_queue_closed_exception_types(int index, ::tensorflow::error::Code value) {
  queue_closed_exception_types_.Set(index, value);
  // @@protoc_insertion_point(field_set:tensorflow.QueueRunnerDef.queue_closed_exception_types)
}
inline void QueueRunnerDef::add_queue_closed_exception_types(::tensorflow::error::Code value) {
  queue_closed_exception_types_.Add(value);
  // @@protoc_insertion_point(field_add:tensorflow.QueueRunnerDef.queue_closed_exception_types)
}
inline const ::google::protobuf::RepeatedField<int>&
QueueRunnerDef::queue_closed_exception_types() const {
  // @@protoc_insertion_point(field_list:tensorflow.QueueRunnerDef.queue_closed_exception_types)
  return queue_closed_exception_types_;
}
inline ::google::protobuf::RepeatedField<int>*
QueueRunnerDef::mutable_queue_closed_exception_types() {
  // @@protoc_insertion_point(field_mutable_list:tensorflow.QueueRunnerDef.queue_closed_exception_types)
  return &queue_closed_exception_types_;
}

#ifdef __GNUC__
  #pragma GCC diagnostic pop
#endif  // __GNUC__

// @@protoc_insertion_point(namespace_scope)

}  // namespace tensorflow

// @@protoc_insertion_point(global_scope)

#include <google/protobuf/port_undef.inc>
#endif  // PROTOBUF_INCLUDED_tensorflow_2fcore_2fprotobuf_2fqueue_5frunner_2eproto