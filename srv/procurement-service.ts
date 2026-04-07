const cds = require('@sap/cds');
const { safeSendToAICore } = require('./util/AICore');

module.exports = class ProcurementService extends cds.ApplicationService {
    async init() {
        const { Products } = this.entities;

        /**
         * getStockAdvice — Dedicated AI Tool for the Joule Agent.
         * Called explicitly when Joule needs a stock recommendation for a product.
         * Fetches live product data, sends it to the Generative AI Hub,
         * and returns a plain-text recommendation string.
         */
        this.on('getStockAdvice', async (req: any) => {
            const { productName } = req.data;

            if (!productName) {
                return 'Please provide a valid product name.';
            }

            // 1. Fetch the product from the database
            const product = await SELECT.one.from(Products).where({ name: productName });

            if (!product) {
                return `Product '${productName}' was not found in our inventory system.`;
            }

            // 2. Build the prompt with real data
            const prompt = [
                'You are an expert SAP procurement and warehouse advisor.',
                `Product: "${product.name}"`,
                `Category: ${product.category || 'N/A'}`,
                `Current stock level: ${product.current_stock_level}`,
                `Safety stock level: ${product.safety_stock_level}`,
                '',
                'Based on the data above, write a concise 2-sentence stock status update.',
                'Sentence 1: State whether this product is above or below its safety stock threshold.',
                'Sentence 2: Give one clear, actionable recommendation (e.g., reorder, hold, redistribute).',
                '',
                'Return ONLY valid JSON matching this structure:',
                '{ "recommendation": "Your two sentences here." }',
                'Do NOT use markdown or code fences.'
            ].join('\n');

            const payload = {
                messages: [
                    { role: 'system', content: 'You are a helpful SAP procurement assistant. Always respond with valid JSON.' },
                    { role: 'user', content: prompt }
                ],
                max_tokens: 200,
                temperature: 0.3
            };

            // 3. Call the Generative AI Hub via SAP AI Core
            const aiResponse = await safeSendToAICore(payload);

            // 4. Return the plain-text recommendation to Joule
            if (aiResponse.success && aiResponse.parsedData?.recommendation) {
                return aiResponse.parsedData.recommendation;
            }

            return 'AI insight could not be generated at this time. Please try again later.';
        });

        return super.init();
    }
};
