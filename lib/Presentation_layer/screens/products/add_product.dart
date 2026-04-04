import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Business_logic_layer/products/products_cubit.dart';
import '../../../data_layer/products/products.dart';
import '../../../styles/color.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();


  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration customInput(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background_Color,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}
            ,icon: Icon(Icons.arrow_back_ios_new),),
        title: const Text("Add Product"),
        centerTitle: true,
        backgroundColor: primColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is AddProductSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("✅ Product added successfully"),
                  backgroundColor: primColor,
                ),
              );
              Navigator.pop(context);
            } else if (state is AddProductErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  /// 🟢 Title
                  TextFormField(
                    controller: _titleController,
                    decoration: customInput("Product Title"),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
                  ),

                  const SizedBox(height: 16),

                  /// 🟢 Price
                  TextFormField(
                    controller: _priceController,
                    decoration: customInput("Price"),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      if (double.tryParse(v) == null) return "Invalid number";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// 🟢 Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: customInput("Description"),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 30),

                  /// 🟢 Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: state is AddProductLoadingState
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        final product = Products(
                          title: _titleController.text,
                          price: double.parse(_priceController.text),
                          description: _descriptionController.text,
                          brand: "Unknown",
                          category: "smartphones",
                          images: [
                            "https://i.imgur.com/QkIa5tT.jpeg"
                          ],
                        );

                        context
                            .read<ProductsCubit>()
                            .addProduct(product);
                      }
                    },
                    child: state is AddProductLoadingState
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Add Product",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}