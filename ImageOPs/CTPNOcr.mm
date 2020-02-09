//
//  CTPNOcr.m
//  ImageOPs
//
//  Created by lincoln on 2020/2/7.
//  Copyright © 2020 lincoln. All rights reserved.
//

#import "CTPNOcr.h"
#include <fstream>
#include <pthread.h>
#include <unistd.h>
#include <queue>
#include <sstream>
#include <string>

#include "tensorflow/core/framework/op_kernel.h"
#include "tensorflow/core/public/session.h"

#define modle_input_height 32.0
#define modle_input_width 280.0

namespace {
    class IfstreamInputStream : public ::google::protobuf::io::CopyingInputStream {
    public:
        explicit IfstreamInputStream(const std::string& file_name)
        : ifs_(file_name.c_str(), std::ios::in | std::ios::binary) {}
        ~IfstreamInputStream() { ifs_.close(); }
        
        int Read(void* buffer, int size) {
            if (!ifs_) {
                return -1;
            }
            ifs_.read(static_cast<char*>(buffer), size);
            return (int)ifs_.gcount();
        }
        
    private:
        std::ifstream ifs_;
    };
}  // namespace


@implementation CTPNOcr
NSString* FilePathForResourceName(NSString* name, NSString* extension) {
    NSString* file_path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    if (file_path == NULL) {
        LOG(FATAL) << "Couldn't find '" << [name UTF8String] << "."
        << [extension UTF8String] << "' in bundle.";
    }
    return file_path;
}

bool PortableReadFileToProto(const std::string& file_name,
                             ::google::protobuf::MessageLite* proto) {
    ::google::protobuf::io::CopyingInputStreamAdaptor stream(
                                                             new IfstreamInputStream(file_name));
    stream.SetOwnsCopyingStream(true);
    // TODO(jiayq): the following coded stream is for debugging purposes to allow
    // one to parse arbitrarily large messages for MessageLite. One most likely
    // doesn't want to put protobufs larger than 64MB on Android, so we should
    // eventually remove this and quit loud when a large protobuf is passed in.
    ::google::protobuf::io::CodedInputStream coded_stream(&stream);
    // Total bytes hard limit / warning limit are set to 1GB and 512MB
    // respectively.
    coded_stream.SetTotalBytesLimit(1024LL << 20, 512LL << 20);
    return proto->ParseFromCodedStream(&coded_stream);
}

float neg_inf = -std::numeric_limits<float>::max();

void ctt_beam_decode( float* data ,  const std::vector<tensorflow::int64>& dims ){
    tensorflow::int64 sequence_length = dims[0];
    tensorflow::int64 batch = dims[1];
    tensorflow::int64 codes = dims[2];
    //tensorflow::int64  ele_size = sequence_length * batch * codes;
    //处理raw数据
    for (tensorflow::int64 seq = 0; seq < sequence_length; ++seq) {
        for (tensorflow::int64 batch_idx = 1;  batch_idx <= batch; ++batch_idx) {
            float max_coff = neg_inf;
            tensorflow::int64 pos = seq  * batch_idx * codes;
            for( tensorflow::int64 col = 0; col < codes; ++col ){
                tensorflow::int64 vist_pos = pos + col;
                if (  data[vist_pos] > max_coff ) {
                    max_coff = data[vist_pos];
                }
            }
            
            float sum = 0.0;
            for( tensorflow::int64 col = 0; col < codes; ++col ){
                tensorflow::int64 vist_pos = pos + col;
                data[vist_pos]  = exp( data[vist_pos] - max_coff );
                sum += data[vist_pos];
            }
            
            for( tensorflow::int64 col = 0; col < codes; ++col ){
                tensorflow::int64 vist_pos = pos + col;
                data[vist_pos] = log( data[vist_pos] / sum);
                //data[vist_pos] =  data[vist_pos] / sum; //softmax
            }
        }
    }
    //
    std::vector<uint32_t> ch_decode;
    float score = 0.0;
    //score = greedy_decode(data, sequence_length, batch, codes, ch_decode);
    //score = prefix_beam_search_decode(data, sequence_length, batch, codes, ch_decode);
    
    batch = 1;
    
}

+ (NSString*) RunInferenceOnImage: (UIImage*) img; {
    tensorflow::SessionOptions options;
    
    tensorflow::Session* session_pointer = nullptr;
    tensorflow::Status session_status = tensorflow::NewSession(options, &session_pointer);
    if (!session_status.ok()) {
        std::string status_string = session_status.ToString();
        return [NSString stringWithFormat: @"Session create failed - %s",
                status_string.c_str()];
    }
    std::unique_ptr<tensorflow::Session> session(session_pointer);
    //tensorflow::Session* session = session_pointer;
    
    LOG(INFO) << "Session created.";
    
    tensorflow::GraphDef tensorflow_graph;
    LOG(INFO) << "Graph created.";
    
    // 1. Load the model
    //NSString* network_path = FilePathForResourceName(@"tensorflow_inception_graph", @"pb");
    NSString* network_path = FilePathForResourceName(@"ocr_opt", @"pb");
    //* network_path = FilePathForResourceName(@"tensorflow_template_application_model", @"pb");
    
    PortableReadFileToProto([network_path UTF8String], &tensorflow_graph);
    
    LOG(INFO) << "Creating session.";
    tensorflow::Status s = session->Create(tensorflow_graph);
    if (!s.ok()) {
        LOG(ERROR) << "Could not create TensorFlow Graph: " << s;
        return @"";
    }
    
    NSString* result = [network_path stringByAppendingString: @" - loaded!"];
    LOG(INFO) << result;
    
    std::string keys_input = "input";
    tensorflow::Tensor input_tensor(tensorflow::DT_FLOAT,tensorflow::TensorShape({1, (int)modle_input_height, (int)modle_input_width,3}));
    //CFDataRef data =  CopyImagePixels(img.CGImage);
    //const unsigned char * buffer =  CFDataGetBytePtr(data);
    //const CFIndex len = CFDataGetLength(data);
    size_t len = 0;
    unsigned char * buffer = nil;//getGrayImageData(img, len);
    CGSize imgsize = img.size;
    //float
    int target_data_len = (int)modle_input_height * (int)modle_input_width;
    float* target_data = new float[target_data_len];
    /*for (int row = 0;  row < (int)modle_input_height ; ++row) {
        int img_row_pos = row * (int)imgsize.width;
        int data_row_pos = row *  (int)modle_input_width;
        for(int col = 0; col < (int)modle_input_width;  ++ col ){
            int data_pos = data_row_pos + col;
            if(col < imgsize.width){
                int img_pos = img_row_pos + col;
                target_data[data_pos] = ((float)buffer[img_pos] / 127.5) - 1.0;
            }else{
                target_data[data_pos] = 1.0;
            }
        }
    }*/
    auto feature = input_tensor.tensor<float, 4>();
    float* t_data = feature.data();
    //for (int row = 0; row < 3; ++row) {
    //    int pos = row * target_data_len;
    //    memcpy(t_data+pos, target_data, target_data_len);
    //}
    
    for(int rowidx = 0;  rowidx < (int)modle_input_height; ++rowidx){
        //int rowpos = rowidx * modle_input_width * 3;
        int imgpos = rowidx * (int)modle_input_width;
        for(int colidx = 0; colidx < (int)modle_input_width; ++colidx){
            //int fil_data_pos = rowpos + colidx * 3;
            int src_data_pos = imgpos + colidx;
            //t_data[fil_data_pos++] = target_data[src_data_pos];
            //t_data[fil_data_pos++] = target_data[src_data_pos];
            //t_data[fil_data_pos] = target_data[src_data_pos];
            feature(0,rowidx, colidx, 0) = target_data[src_data_pos];
            feature(0,rowidx, colidx, 1) = target_data[src_data_pos];
            feature(0,rowidx, colidx, 2) = target_data[src_data_pos];
        }
    }
    /*NSString* csv_path = FilePathForResourceName(@"cc", @"csv");
    const std::string str_csv = [csv_path UTF8String];
    MatrixCSV csv(str_csv);
    for(int rowidx = 0;  rowidx < csv.rows() ; ++rowidx){
        for(int colidx = 0;  colidx < csv.cols() ; ++colidx){
            feature(0,rowidx, colidx, 0) = csv.getAt(rowidx, colidx);
            feature(0,rowidx, colidx, 1) = csv.getAt(rowidx, colidx);
            feature(0,rowidx, colidx, 2) = csv.getAt(rowidx, colidx);
        }
    }*/
    
    //memcpy
    delete []target_data;
    //CFRelease(data);
    free(buffer);
    
    std::string keys_out =   "shadow_net/sequence_rnn_module/transpose_time_major";
    std::vector<tensorflow::Tensor> output_tensors;
    //auto features_data = input_tensor.tensor<float, 4>();
    //for (int i = 0; i < 92160; ++i) {
    //    features_data(0, i) = 1.0;
    //}
    
    //tensorflow::Tensor key()
    //session->Run(<#const std::vector<std::pair<string, Tensor> > &inputs#>, <#const std::vector<string> &output_tensor_names#>, <#const std::vector<string> &target_node_names#>, <#std::vector<Tensor> *outputs#>)
    
    
    tensorflow::Status run_status = session->Run({{keys_input, input_tensor}}, {keys_out}, {}, &output_tensors);
    
    if (!run_status.ok()) {
        LOG(ERROR) << "Running model failed: " << run_status;
        tensorflow::LogAllRegisteredKernels(); 
        result = @"Error running model";
        return @"";
    }
    
    //tensorflow::Tensor keys_tensor(tensorflow::DT_INT32,tensorflow::TensorShape({1, 1}));
    /*auto keys_data = keys_tensor.tensor<int, 2>();
    keys_data(0, 0) = 1;*/
    
    // 4. Parse outputs
    tensorflow::string status_string = run_status.ToString();
    result = [NSString stringWithFormat: @"%@ - %s", result, status_string.c_str()];
    tensorflow::Tensor* output2 = &output_tensors[0];
    auto prediction2 = output2->flat<float>();
    const long count = prediction2.size();
    float* pre_data = prediction2.data();
    
    auto out_data =  output2->tensor<float, 3>();
    
    const tensorflow::TensorShape& shape =  output2->shape();
    const int dims = shape.dims();
    std::vector<tensorflow::int64> out_dims;
    for (int i = 0; i < dims; ++i) {
        out_dims.push_back( shape.dim_size(i) );
    }
    
    ctt_beam_decode(pre_data, out_dims);
    
    tensorflow::Tensor features_tensor(tensorflow::DT_FLOAT,tensorflow::TensorShape({1, 9}));
    /*auto features_data = features_tensor.tensor<float, 2>();
    for (int i = 0; i < 9; ++i) {
        features_data(0, i) = 1.0;
    }*/
    
    
   

    
    return @"";
}



@end
