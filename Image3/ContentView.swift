//
//  ContentView.swift
//  Image3
//
//  Created by Melo on 1/28/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var showImagePicker = false
    
    @State private var inputImage: UIImage?
    @State private var processedImage:UIImage?
    
    @State private var image:Image?
    
    @State private var blurEffectSlider:Float = 0
    @State private var sepiaEffectSlider:Float = 0
    
    var body: some View {
        NavigationView{
            VStack{
               
                if image != nil {
                    VStack{
                        image?
                            .resizable()
                            .frame(width: 300, height: 300, alignment: .center)
                        HStack{
                            Text("Blur")
                            Slider(value: $blurEffectSlider, in: 0...10)
                                .onChange(of: blurEffectSlider, perform: { value in
                                    applyEffect()
                                })
                        }
                        HStack{
                            Text("Sepia")
                            Slider(value: $sepiaEffectSlider, in: 0...10)
                                .onChange(of: sepiaEffectSlider, perform: { value in
                                    applyEffect()
                                    
                                })
                        }
                        
                        
                    }
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.gray.opacity(0.2)))
                }
                else {
                    Text("No Image Selected")
                        .font(.largeTitle)
                }
               
            }
            .navigationTitle(Text("Photo Editor"))
            .navigationBarItems(leading: Button(action: {
                showImagePicker.toggle()
            }, label: {
                Image(systemName: "photo.fill.on.rectangle.fill")
            }), trailing: Button(action: {
                UIImageWriteToSavedPhotosAlbum(processedImage!, nil, nil, nil)
            }, label: {
                Text("Save")
            }))
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: $inputImage)
            })
        }
    }
    
    func applyEffect() {
        let context = CIContext()
        let blur = CIFilter.gaussianBlur()
        blur.inputImage = CIImage(image: inputImage!)
        blur.radius = blurEffectSlider
        
        let sepia = CIFilter.sepiaTone()
        sepia.inputImage = CIImage(image: inputImage!)
        sepia.intensity = sepiaEffectSlider
        
        sepia.setValue(blur.outputImage, forKey: "inputImage")
        
        if let output = sepia.outputImage {
            if let cgimg = context.createCGImage(output, from: output.extent) {
                var processedUIImage = UIImage(cgImage: cgimg)
                image = Image(uiImage: processedUIImage)
                processedImage = processedUIImage
                
            }
                
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
            
        }
        image = Image(uiImage: inputImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
